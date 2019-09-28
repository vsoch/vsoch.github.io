---
title: "Discovering Parts of Composite Parts"
date: 2019-09-28 12:05:00
categories: rse
---

Welcome to the universe of parts! Here we have "Parts," or sequences of letters,
and "Composite Parts," or combined Parts, each with an ordering and direction.
If you can't tell, these are sequences. I'm not a biologist, so I apologize in
advance for all my misspeaks and ignorance to all the biologists reading this post. Now 
here are the two parts - let's call them our base parts:

```python

base1='AAACACGTGGCAAACATTCCGGTCTCTATGAAGAGCTTCGAGACCAAAGGGGCCGTCAATATCAGCAGAGACATCGGTGCGCATACAGGCTCCCTGT
AGGCTCCGCGAGATAACGTAGACAGGTTGTTTTGACTAGTGGTTCAAAGGCCTACTCCCCCAAATCTGCCTATCACAAGTTCAGTCGAAAAGCATAGTAAGCGCCCCAA
TTTGCCAGTCGCAACAAGTCTGAGACCTACTAGTAGGGGAGATGATGCTTACCGCGGTCCTGAAGCGCAAGACGGGGTGAATGGCCCCGTTCTGCTATGGTTCTCAAGG
TAGTATGTGCATTGCTCTTAGTGAACTAGGGATAACAGGGTAATATAGAGGGATTGGTACCAAGT'

base2='GGTCTCAAATGAATAAAAAGGAGATCTTTAACACTGACTTCTTTGAATCTGGACTTGCCTACATCTTAACCAACCTTGATTTCATCCAAGAAGAGTTAGAGCAA
GAGAAGCTGCAAACCTCTCTTGTTGAAAAACTTATTACTGATTTTGAGGACGTCGAGGATTATGAGACATGGGACCTTTTGACTAACAATTTGATTCAAAGTGAAGATA
AGATCCTTGAGGAGATTCAGAAGATCAAGGACTCTACAAAATTTAATTTGCTGAATAGCTACTTCCTTGCCAAAAACCTGGCAATCTATTTAAAGTCCAATTCTTTTCT
TATCGAACAAATCAATAAGTTACAGACAAATAGTCCTGACGACCTTTCTGAAGATAAAAAGGAGGAGTTCATTAACAACCTGAAACAAGAGATTTTGAAAAACAATTCT
GAATTATATAAGCAAAACGAACGCTTGTTTAAGGAAATCTTTGACAAAAAGGTTGAATTTAAGAAGATTTATCAACTGCTGATTAAGGAAACCGAGTTTGAGGACTTCA
ACTATGCGAACGAGTTATTGTTTAATATGTTAAATAATAATTTTAAGTTCAACAATAAACAGGACCTTTTAAAACTTGAGGTCCTGAACAACGCCCAGAGCCTGATTGA
TTTTTTGACGTTTTACGAGAGCTCTTTGTTTGATGATGAAAAGGAGTGAAGAGCTTAGAGACC'
```

Let's now combine them into a new composite part,
and create a fun name. Because we want to be tricky, we are going to reverse the second:

```python

> name = "Dinosaur Part"
> sequence = base1 + base2[::-1]
```

The direction of the above is represented as "><" meaning that the first part is in the
forward direction, and the second is reversed. We now have a sequence that is a combination of parts. We also have (not shown) a complete query result (a JSON object) from an API that gives us ALL the parts (~3000) in a database. 
They are indexed by a unique id, and each one includes a rich set of metadata. Here is an example of one entry, and  I've truncated the sequences and removed empty fields for brevity:

```python

{'uuid': '81a92bdc-2b71-48de-bdfc-fafcf9bf26ed',
 'name': 'MG_RS01350',
 'status': 'Unapproved',
 'gene_id': 'BBF10K_002166',
 'part_type': 'cds',
 'genbank': {'gene': '',
  'note': 'Derived by automated computational analysis usinggene prediction method: Protein Homology.',
  'Source': 'Mycoplasma genitalium G37',
  'product': 'ribonucleoside-diphosphate reductase subunitbeta',
  'locus_tag': 'MG_RS01350',
  'protein_id': 'WP_009885766.1',
  'GenBank_acc': 'NC_000908 NZ_U39679-NZ_U39729',
  'translation': 'MAANNKKYFLES',
  'gene_synonyms': ''},
 'original_sequence': 'ATGGCAGCTAACAATAAAAA...',
 'optimized_sequence': 'ATGGCTGCAAATAATAAAAAGTAT...',
 'synthesized_sequence': 'AAGGAACTATGGCATCGAGCGGTCTCA...',
 'primer_forward': 'AAGGAACTATGGCATCGAGC',
 'primer_reverse': 'GTACGTCTGAACTTGGGACT',
 'label': 'part',
 'translation': 'MAANNKKYFLESFSPLGYVKNNFQGNL*',
 'tags': [{'name': 'mycoplasma',
   'uuid': '53edbc05-ca3f-4246-9b7f-35c766e7af3e'},
  {'name': 'cds', 'uuid': '3bc7e754-f6b5-424c-9910-8adcb5d59d9e'},
  {'name': 'moclo', 'uuid': '63d87aa1-782a-4f97-94c9-44587d1236d3'},
  {'name': 'mycoplasma genitalium',
   'uuid': '8cdc02fc-5871-4629-afc7-4903703a9edb'}],
 'collections': [],
 'author': {'name': 'Mickey Mouse',
  'uuid': '47a4b50c-3176-4579-8895-3f902fee26bf'}}
```

## The Challenge

Our challenge is to, given a query sequence such as the one we generated above, 
find the matching parts and their directions.
The real life scenario is using a create endpoint of an API to add a composite part, but to do this we would
need the parts, a name, and the directions. Since this would be too computationally intensive to do
on a server, I decided to have the client (a Python module that wraps the API) do the bulk of
work, and then submit the final part identifier and directions for validation. Our
final algorithm (run on a client computer) should be something like this:

<ol class="custom-counter">
   <li>Cache all parts from the API (one call)</li>
   <li>Find all forward and reverse substrings that match (starts, ends, and length)</li>
   <li>Model as scheduling problem</li>
</ol>

### Step 1: Cache the Parts

The user is likely going to want to make many Composite Parts in one fell swoop, and
since the existing parts in the server database is set at a few thousand, it was logical to
do a single query to get all these parts and cache it locally with the client.
I don't need to show the logic behind this - we add a caching function to the client
that is called in our TBA function to generate a new composite part:

```python
> client._cache_parts()
```

### Step 2: Find Substrings

This is fairly straight forward - each part can be represented in the forward direction
(e.g., ABC) or the reverse direction (CBA) in the sequence. Let's loop through our parts,
and save all occurrences (meaning the unique (uuid) of the part, it's direction,
start and stopping index) in a list.

```python

# Parts found to match
coords = []

for uuid, part in self.cache['parts'].items():

    # Only use parts with optimized sequences
    if part.get('optimized_sequence'):
        forward = part['optimized_sequence']
        reverse = forward[::-1]

        # Case 1: we found the forward sequence
        if forward in sequence:
            for match in re.finditer(forward, sequence): 
                coords.append((part.get('uuid'), ">", match.start(), match.end()))

        # Case 2: we found the reverse sequence
        if reverse in sequence:
            for match in re.finditer(reverse, sequence): 
                coords.append((part.get('uuid'), "<", match.start(), match.end()))

```

That is fairly simple! And we are greatly helped by the <a href="https://docs.python.org/2/library/re.html#re.finditer" target="_blank">re.finditer</a>
function, which will return all matches (as re match objects) in the string. If we used re.search
we'd only get the first (and need to chop it off to find the rest) and if we used re.findall we'd
get the strings themselves (not super useful).

### Step 3: Make a Queue!

For some reason, I've always loved algorithms that use queues. They tend to be more intuitive,
and sort of fun, because you are processing the queue like a robot. In our case,
we want to sort the queue based on the length of the match, where the longest match
will be at the end of the list, and the shortest at the start. For example, here is an entry in our
list of coords (matches):

```python

# uuid,  direction, start, end
('81a92bdc-2b71-48de-bdfc-fafcf9bf26ed', '>', 0, 1023)
```

The above would say that "Part with unique id 81a92bdc-2b71-48de-bdfc-fafcf9bf26ed was found
in the sequence in the forward (>) direction, starting at index 0, and ending at index 1023.
This means to calculate the length, we subtract the end from the start. There is a nice
Pythonic way to do that, and generate our sorted queue from the list of coords:

```python

# Make a queue sorted by how long they (end - start)
queue = sorted(coords, key=lambda tup: tup[3]-tup[2])
```

### Step 4: Overlaps With Function

I'd want to have a function that returns a boolean if some new contender element
overlaps with any current parts in some list of selected sequences. There are probably
cleaner ways to do this, but I spelled it out verbatim: I loop through the selected
sequences (by the way, this starts as an empty list, and we would add the first 
element in the queue to it) and check if the contender element start or end is within
the range of a selected sequence start through end (i.e., it overlaps).

```python

def overlaps_with(selected_sequences, element):
    '''determine if an element overlaps with any current elements in the list
    '''
    for selected in selected_sequences:

       # If the element start is greater than selected start, less than end
       if (element[2] >= selected[2]) and (element[2] < selected[3]):
           return True

       # If the element end is greater than the selected start, less than end
       if (element[3] > selected[2]) and (element[3] <= selected[3]):
           return True

    return False
```

We return a boolean to indicate overlapping or not.

### Step 5: Process the Queue

I think this is a basic scheduling algorithm - we start with a queue of start and ending
times (sorted by length), and while this isn't the greedy "optimal" <a href="https://en.wikipedia.org/wiki/Interval_scheduling#Greedy_polynomial_solution" target="_blank">solution</a>, I chose this method
because I think what I want is to match the longer ones first. For example, it could be there's a lot of short sequences that can assemble together to formulate some portion of the query sequence, but we probably want to match the longer ones first because those are more likely to be important. It could be that there be other matching subsequences that don't include the longest, and we can talk more about this after. Let's first create an empty list of selected_sequences, and then add popped elements from the queue (remember, longest first!) only if there is no overlap with already added members:

```python

selected_sequences = []

while queue:

    # Pop the longest element ( the last )
    element = queue.pop()

    # If there is no overlap add
    if not overlaps_with(selected_sequences, element):
        selected_sequences.append(element)

```

At the end of this loop I have a nice list of (non-sorted) sequences that don't overlap.

### Step 6: Sort by Start

Here is a peek at the result from running the algorithm with our dummy data - we have a subset of the initial matches that don't overlap.

```python

[('e7d46d00-e32e-417b-8628-0f5287d55840', '<', 1023, 1866),
 ('81a92bdc-2b71-48de-bdfc-fafcf9bf26ed', '>', 0, 1023)]
```

As you can see, the ordering can be off! So we need to do one more sort, but this time based
on the starting position (the second index counting with 0) and not the length:

```python
> selected_sequences = sorted(selected_sequences, key=lambda tup: tup[2])
```

And then we're done! We can make a POST request to the API with our final 
list of part unique ids (they will be looked up and validated to exist in the database)
along with a direction string (which must be the same length as the number of parts)

```python

data = {"name": name, 
        "parts": ['81a92bdc-2b71-48de-bdfc-fafcf9bf26ed', 'e7d46d00-e32e-417b-8628-0f5287d55840'], 
        "sequence": sequence, 
        "direction_string": "><"} 
```

That's the POST data, I don't need to show you the actual request. The API returns
the created object, in case the user wants it locally or to verify anything. But actually,
the user isn't exposed to all of that code, the client presents all of the above
as a single, clean function:

```python

> composite_part = client.create_composite_part(name=name, sequence=sequence)
```

## All Possible Matches?

In practice, when I did this there were about ~20 matches in my original list, 2 of which were the original
parts I selected, and the rest which were small optimized sequences (3 base pairs!) that
tended to repeat a ton of times. What I tried doing (just for testing) was to remove
the first (the longest, the real first half) and then the second (the second longest, the real second half)
from the queue, and run it again. I did find some form of result with the small
optimized sequence (of length 3) repeated many times - here is removing the first:

```python

[('129e6622-1f82-4de0-a24d-427d513f005d', '<', 19, 22),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 104, 107),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 182, 185),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 205, 208),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 226, 229),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 250, 253),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 284, 287),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 310, 313),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 326, 329),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 475, 478),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 505, 508),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 515, 518),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 529, 532),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 622, 625),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 632, 635),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 715, 718),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 731, 734),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 736, 739),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 748, 751),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 752, 755),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 772, 775),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 817, 820),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 919, 922),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 989, 992),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 1004, 1007),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 1020, 1023),
 ('e7d46d00-e32e-417b-8628-0f5287d55840', '<', 1023, 1866)]
```

And here is removing the second:

```python

[('81a92bdc-2b71-48de-bdfc-fafcf9bf26ed', '>', 0, 1023),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1023, 1026),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1052, 1055),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1088, 1091),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1124, 1127),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1127, 1130),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1148, 1151),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1193, 1196),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1225, 1228),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1322, 1325),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1355, 1358),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1394, 1397),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1418, 1421),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1477, 1480),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1496, 1499),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1501, 1504),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1571, 1574),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1595, 1598),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1637, 1640),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1690, 1693),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '>', 1753, 1756),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1760, 1763),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1778, 1781),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1832, 1835),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1841, 1844),
 ('129e6622-1f82-4de0-a24d-427d513f005d', '<', 1853, 1856)]
```

And you could imagine a third case of removing both the first and second,
and getting an answer of entirely the same Part in various directions.
And maybe these would be wanted? But at least to start, i didn't implement anything
to search for these. Hey, I'm not exactly a biologist, but I'll figure this out as I go!

### Anyway, that was fun!
