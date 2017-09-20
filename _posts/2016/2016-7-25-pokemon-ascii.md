---
title: "Pokemon Ascii Avatar Generator"
date: 2016-7-25 12:00:00
---

An avatar is a picture or icon that represents you. In massive online multiplayer role playing games (MMORPGs) your "avatar" refers directly to your character, and the computer gaming company Origin Systems took this symbol literally in its <a href="https://en.wikipedia.org/wiki/Avatar_(Ultima)" target="_blank" >Ultima series of games</a> by naming the lead character "The Avatar."



# Internet Avatars
If you are a user of this place called the Internet, you will notice in many places that an icon or picture "avatar" is assigned to your user. Most of this is thanks to a service called <a href="https://en.gravatar.com/site/implement/images/" target="_blank">Gravatar</a> that makes it easy to generate a profile that is shared across sites. For example, in developing <a href="https://github.com/singularityware/singularity-hub" target="_blank">Singularity Hub</a> I found that there are many <a href="http://django-avatar.readthedocs.io/en/latest/" target="_blank">Django plugins</a> that make adding a user avatar to a page as easy as adding an image with a source (src) like `https://secure.gravatar.com/avatar/hello`.

The final avatar might look something like this:

<img src="https://secure.gravatar.com/avatar/hello?r=g&s=100&d=retro" width="100px">

This is the "retro" design, and in fact we can choose from one of many:

<div>
    <img src="/assets/images/posts/pokemon-ascii/gravatar_designs.png" style="width:800px"/>
</div><br>


## Command Line Avatars?
I recently started making a command line application that would require user authentication. To make it more interesting, I thought it would be fun to give the user an identity, or minimally, something nice to look at at starting up the application. My mind immediately drifted to avatars, because an access token required for the application could equivalently be used as a kind of unique identifier, and a hash generated to produce an avatar. But how can we show any kind of graphic in a terminal window?

<div>
    <img src="/assets/images/posts/pokemon-ascii/terminal.png" style="width:800px"/>
</div><br>


## Ascii to the rescue!
Remember chain emails from the mid 1990s? There was usually some message compelling you to send the email to ten of your closest friends or face immediate consequences (cue diabolical flames and screams of terror). And on top of being littered with exploding balloons and kittens, <a href="https://en.wikipedia.org/wiki/ASCII_art" target="_blank">ascii art</a> was a common thing.


```

 __     __        _           _                     _ 
 \ \   / /       | |         | |                   | |
  \ \_/ /__  __ _| |__     __| | __ ___      ____ _| |
   \   / _ \/ _` | '_ \   / _` |/ _` \ \ /\ / / _` | |
    | |  __/ (_| | | | | | (_| | (_| |\ V  V / (_| |_|
    |_|\___|\__,_|_| |_|  \__,_|\__,_| \_/\_/ \__, (_)
                                               __/ |  
                                              |___/   
```


# Pokemon Ascii Avatars!
I had a simple goal - to create a command line based avatar generator that I could use in my application. Could there be any cute, sometimes scheming characters that be helpful toward this goal? Pokemon!! Of course :) Thus, the idea for the pokemon ascii avatar generator was born. If you want to skip the fluff and description, <a href="https://github.com/vsoch/pokemon-ascii" target="_">here is pokemon-ascii</a>.

### Generate a pokemon database
Using the <a href="http://pokemondb.net/pokedex/national" target="_blank">Pokemon Database</a> I wrote a <a href="https://github.com/vsoch/pokemon-ascii/blob/master/scripts/make_db.py" target="_blank">script</a> that produces a <a href="https://raw.githubusercontent.com/vsoch/pokemon-ascii/master/pokemon/database/pokemons.json" target="_blank">data structure</a> that is stored with the module, and makes it painless to retrieve meta data and the ascii for each pokemon. The user can optionally run the script again to re-generate/update the database. It's quite fun to watch!

<div>
    <img src="https://github.com/vsoch/pokemon-ascii/raw/master/img/generation.gif" style="width:1000px"/>
</div><br>

The Pokemon Database has a unique ID for each pokemon, and so those IDs are the keys for the dictionary (the json linked above). I also store the raw images, in case they are needed and not available, or (in the future) if we want to generate the ascii's programatically (for example, to change the size or characters) we need these images. I chose this "pre-generate" strategy over creating the ascii from the images on the fly because it's slightly faster, but there are definitely good arguments for doing the latter.

<div>
    <img src="/assets/images/posts/pokemon-ascii/pokemon.png" style="width:1000px"/>
</div><br>


### Method to convert image to ascii

I first started with my own intuition, and decided to read in an image using the Image class from PIL, converting the RGB values to integers, and then mapping the integers onto the space of ascii characters, so each integer is assigned an ascii. I had an idea to look at the number of pixels that were represented in each character (to get a metric of how dark/gray/intense) each one was, that way the integer with value 0 (no color) could be mapped to an empty space. I would be interested if anyone has insight for how to derive this information. The closest thing I came to was determining the number of bits that are needed for different data types:

```
# String
"s".__sizeof__()
38

# Integer
x=1
x.__sizeof__()
24

# Unicode
unicode("s").__sizeof__()
56

# Boolean
True.__sizeof__()
24

# Float
float(x).__sizeof__()
24
```

Interesting, a float is equivalent to an integer. What about if there are decimal places?

```
float(1.2222222222).__sizeof__()
24
```

Nuts! I should probably not get distracted here. I ultimately decided it would be most reasonable to just make this decision visually. For example, the `@` character is a lot thicker than a `.`, so it would be farther to the right in the list. My first efforts rendering a pokemon looked something like this:

<div>
    <img src="/assets/images/posts/pokemon-ascii/attempt1.png" style="width:1000px"/>
</div><br>

I then was browsing around, and found a <a href="https://www.hackerearth.com/notes/beautiful-python-a-simple-ascii-art-generator-from-images/" target="_blank">beautifully done implementation</a>. The error in my approach was not normalizing the image first, and so I was getting a poor mapping between image values and characters. With the normalization, my second attempt looked much better:

<div>
    <img src="/assets/images/posts/pokemon-ascii/attempt2.png" style="width:1000px"/>
</div><br>

I ultimately modified this code sightly to account for the fact that characters tend to be thinner than they are tall. This meant that, even though the proportion / size of the image was "correct" when rescaling it, the images always looked too tall. To adjust for this, I modified the functions to adjust the new height by a factor of 2:

```
def scale_image(image, new_width):
    """Resizes an image preserving the aspect ratio.
    """
    (original_width, original_height) = image.size
    aspect_ratio = original_height/float(original_width)
    new_height = int(aspect_ratio * new_width)

    # This scales it wider than tall, since characters are biased
    new_image = image.resize((new_width*2, new_height))
    return new_image
```

Huge thanks, and complete credit, goes to the author of the original code, and a huge thanks for sharing it! This is a great example of why people should share their code - new and awesome things can be built, and the world generally benefits!

### Associate a pokemon with a unique ID
Now that we have ascii images, each associated with a number from 1 to 721, we would want to be able to take some unique identifier (like an email or name) and consistently return the same image. I thought about this, and likely the basis for all of these avatar generators is to use the ID to generate a HASH, and then have a function or algorithm that takes the hash and maps it onto an image (or cooler) selects from some range of features (e.g., nose mouth eyes) to generate a truly unique avatar. I came up with a simple algorithm to do something like this. I take the hash of a string, and then use modulus to get the remainder of that number divided by the number of pokemon in the database. This means that, given that the database doesn't change, and given that the pokemon have unique IDs in the range of 1 to 721, you should always get the same remainder, and this number will correspond (consistently!) with a pokemon ascii. The function is pretty simple, it looks like this:

```
def get_avatar(string,pokemons=None,print_screen=True,include_name=True):
    '''get_avatar will return a unique pokemon for a specific avatar based on the hash
    :param string: the string to look up
    :param pokemons: an optional database of pokemon to use
    :param print_screen: if True, will print ascii to the screen (default True) and not return
    :param include_name: if True, will add name (minus end of address after @) to avatar
    '''
    if pokemons == None:
        pokemons = catch_em_all()

    # The IDs are numbers between 1 and the max
    number_pokemons = len(pokemons)
    pid = numpy.mod(hash(string),number_pokemons)
    pokemon = get_pokemon(pid=pid,pokemons=pokemons)
    avatar = pokemon[pid]["ascii"]
    if include_name == True:
        avatar = "%s\n\n%s" %(avatar,string.split("@")[0])
    if print_screen == True:
        print avatar    
    else:
        return avatar
```

...and the function `get_pokemon` takes care of retrieving the pokemon based on the id, `pid`.

## Why?
On the surface, this seems very silly, however there are many good reasons that I would make something like this. First, beautiful, or fun details in applications make them likable. I would want to use something that, when I fire it up, subtly reminds me that in my free time I am a Pokemon master. Second, a method like this could be useful for security checks. A user could learn some image associated with his or her access token, and if this ever changed, he/she would see a different image. Finally, a detail like this can be associated with different application states. For example, whenever there is a "missing" or "not found" error returned for some function, I could show Psyduck, and the user would learn quickly that seeing Psyduck means "uhoh." 

<div>
    <img src="/assets/images/posts/pokemon-ascii/404.png" style="width:800px"/>
</div>

There are many more nice uses for simple things like this, what do you think?
<br><br>

# Usage

The usage is quite simple, and this is taken straight from the <a href="https://github.com/vsoch/pokemon-ascii" target="_blank">README</a>:

```
      usage: pokemon [-h] [--avatar AVATAR] [--pokemon POKEMON] [--message MESSAGE] [--catch]

      generate pokemon ascii art and avatars

      optional arguments:
        -h, --help         show this help message and exit
        --avatar AVATAR    generate a pokemon avatar for some unique id.
        --pokemon POKEMON  generate ascii for a particular pokemon (by name)
        --message MESSAGE  add a custom message to your ascii!
        --catch            catch a random pokemon!

      usage: pokemon [-h] [--avatar AVATAR] [--pokemon POKEMON] [--message MESSAGE] [--catch]
```
<br>

## Installation

You can install directly from pip:

```
      pip install pokemon
```


or for the development version, clone the repo and install manually:

```

      git clone https://github.com/vsoch/pokemon-ascii
      cd pokemon-ascii
      sudo python setup.py sdist
      sudo python setup.py install
```
<br>


## Produce an avatar

Just use the `--avatar` tag followed by your unique identifier:

```
      pokemon --avatar vsoch

      @@@@@@@@@@@@@*,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@,:::::::::,@@@:,S+@@@@@@@#:::::::,:@@@@@@@@@@@@@@@@
      @@@@@@@@:::::::::****@@**..@@@@@:::::::::::::S@@@@@@@@@@@@@@
      @@@@@@@::::***********#..%.S@@#::::::::::*****S@@@@@@@@@:?@@
      @@@@@@@*****?%%%%?***....SSSS#*****************#@@@@@@@@,::@
      @@@@@@@%***S%%%%%.#*S.SSSSSS?.****?%%%%%#*******@@@@@#:::::.
      @@@@@@@@****%%%%#...#SSSS#%%%?***?%%%%%%%******%@@@@%::::***
      @@@@@@@@@+****SSSSSS?SSS.%...%#SS#%....%.******@@@@@?*******
      @@@@@@@@@@@@#SSSSSSS#S#..%...%%.....%.%.******@@@@@@@#**.**@
      @@@@@@@@@@@..SSSSS..?#.%..%.......%.%.******#@@@@@@@@@@S%,@@
      @@@@@@@@@@#%........................%****%,@@@@@@@@@@@?%?@@@
      @@@@@@@@@@.#*@@@%.................%%%......SSS.SSS%@#%%?@@@@
      @@@@@@@@@%+*@@?,.%....%%.,@,@@,*%.%%%..%%%%.%....%...?#@@@@@
      @@@@@@@@@:*.@#+?,%%%%%.%,@??#@@@**......%........%...%%*@@@@
      @@@@@@@@@@.*.@##@...%%.+@##@?,@@****.....%...%....?...%%@@@@
      @@@@@@@@@@@.**+**#++SS***,*#@@@*****%%.%.......%%........@@@
      @@@@@@@@@@@@************************..........%%.%%...%%*@@@
      @@@@@@@@@@@@@@,?**?+***************.%........#....%%%%%%@@@@
      @@@@@@@@@@@@@@@@@%#*+....*******..%%..%%.....%%%%%%%%%%@@@@@
      @@@@@@@@@@@@@@+%%%%%%??#%?%%%???.%%%%%...%%%.**.**#%%%@@@@@@
      @@S#****.?......%%%%%%?%@@@@@:#........%?#*****.#***#@@@@@@@
      @***%.*S****S**.%%%%%%@@@@@@@S....%%..%@@+*+..%**+%#.@@@@@@@
      @%%..*..*%%+++++%%%%@@@@@@@...%.%%.%.%@@@,+#%%%%++++@@@@@@@@
      @:+++#%?++++++++%%@@.**%**.****#..%%%,@@@@@S+.?++++@@@@@@@@@
      @@@++?%%%?+++++#@@@**.********S**%%%@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@%++++?@@@@@@S%%*#%.**%%**..+%@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@@@@@@@++++++++.S++++#@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@@@@@@@@++%%%%?+++++@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@@@@@@@@@*+#%%%+++%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

      vsoch
```


You can also use the functions on command line (from within Python):


```
      from pokemon.skills import get_avatar
 
      # Just get the string!
      avatar = get_avatar("vsoch",print_screen=False)
      print avatar

      # Remove the name at the bottom, print to screen (default)
      avatar = get_avatar("vsoch",include_name=False)
```
<br>


## Randomly select a Pokemon

You might want to just randomly get a pokemon! Do this with the `--catch` command line argument!

```
      pokemon --catch

      @%,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      .????.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      .???????S@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      :?????????#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      *?????????????*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @???????#?????###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,*.??#
      @?????,##,S???#####@@@@@@@@@@@@@@@@@@@@@@@@@@S##????????????
      @?????*,,,,,,########@@@@@@@@@@@@@@@@@:###????????????????#@
      @##????,,,,,,,,,#####@@@@@@@@@@@@@.######?????#?:#????????@@
      @####?#,,,,,,,,,,,##@@@@@@@@@@@@@@#######*,,,,,*##+?????+@@@
      @######,,,,,,,,,,,S@@@@@@@@@@@@@@#.,,,,,,,,,,,,,,:?####@@@@@
      @######,,,,,,,,,,%@@,S.S.,@@@@@@@,,,,,,,,,,,,,,,######@@@@@@
      @@#####,,,,,,,,.,,,,,,,,,,,,,,,*#,,,,,,,,,,,,,.#####:@@@@@@@
      @@@@@@@@@@.#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,######@@@@@@@@@
      @@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,+######@@@@@@@@@@
      @@@@@@@@%,,,,,++:,,,,,,,,,,,,,,,,,,,,,@@:.######:@@@@@@@@@@@
      @@@@@@@:,,,:##@@@#,,,,,,,,,,,,?@S#,,,,,,@@@@@@@@@@@@@@@@@@@@
      @@@@@@@?,,,#######,,,,,,,,,,,#.@:##,,,:?@@@@@@@@@@@@@@@@@@@@
      @@@@@@@.,,S,??%?*,,,,,,,,,,,,####?%+,::%@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@?..*+,,,,,,*,,,,,,,,,,,+#S,::::*@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@%..*,,,,,,,,,,,,,,,,,,,:.*...%@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@.**::*::::::,,:::::::+.....@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@.@@@@?:**:::*::::::::::*...@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@?,,,,,,,,,:,##S::::**:::S#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@.,,,,,,:S#?##?########:#****#,@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@,%:*%,??#,,,,:*S##**:..****:,.*@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@+,,,,,,,,,,,,,,,,,,*...*:,.,@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@+,,,,,,,,,,,,,,,,,,?@@@@@*#?@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@*,,,,,,,,,,,,,,,,,,.@#########?@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@.*:,,,,,,,,,,,,,,:.##%,?#####????:@@@@@@@@@@@@@
      @@@@@@@@@@@@@@?.....*******....S@@@@@@:##?????@@@@@@@@@@@@@@
      @@@@@@@@@@@@@@S.+..********...#%@@@@@@@@@##,@@@@@@@@@@@@@@@@
      @@@@@@@@@@@#*,,,,*.#@@@@@@@..*:,,*S@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@+@,%,,,#@@@@@@@@@@,S,,,%,,:@@@@@@@@@@@@@@@@@@@@@@@

      Pichu

```

You can equivalently use the `--message` argument to add a custom message to your catch!

```
      pokemon --catch --message "You got me!"

      @@@@@@@@@*.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@...+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@++++@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      :..+,@@+.+++%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @..++++S++++++.?...@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@:S.S+SSS.S%++.+++@@@@@@@@@@+.%.@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@:SSSSSSSSSS,@@@@@@@,:,:.SS+.....+.@@@@@@@@@@@@@@@@@@@@@@
      @@@@,:%SS++SS.,.%,:,S,,,,+..%.........S.@@@@@@@@@@@@@@@@@@@@
      @@@@@,:*...:,,+,.,,,,,,,*%%%++++..+++SSS+@@@@@@@@@@@@@@@@@@@
      @@@@@@,,.....%:,,,:.:.,:.%%.SSSS++SS+%+S%,+@@@@@@@@@@@@@@@@@
      @@@@@@@*.....S...***+,,,%..%++,?SSS.%.%%%:,.,@@@@@@@@@@@@@@@
      @@@@@@@@,+**........,,,,....++S@,+%..#..%,,S..@@@@@@@@@@@@@@
      @@@@@@@@@@@@@@@@*..:,,,,,%..%++S%%.%%.S%%,,*+.+@@@@@@@@@@@@@
      @@@@@@@@@@@@@@@@S,,,,,,,,,%%%..SS..%?%%%,,,S+...@@@@@@@@@@@@
      @@@@@@@@@@@@@@@@S.:::::::::%.%%S...%%%%:::*.....**@@@@@@@@@@
      @@@@@@@@@@@@@@@@.%%..:::::::S%%.?%%%%%:::....**,S,,:@@@@@@@@
      @@@@@@@@@@@@@@:::*%%%%?..*:::,.%%%%.,:*.%@@.*:,,,:,,S@....@@
      @@@@@@@@@@@@@:,:,::*.?%%%%%%?+*%%?.?%%%%%+@@,,,,,,,.++%++@@@
      @@@@@@@@@@@@@@*,,,,,**...*%%%%%%%%%%?++++++.@,,,,,SS+SS++@@@
      @@@@@@@@@@@@@,,.,S,,,,:....***%%?%++++++++++.@.,,+SSSSS.S+@@
      @@@@@@@@@@@@,,SSSS..:.%,:*..?%%??%%++++++.+S+@@@.S..%S.%.S++
      @@@@@@@@@@@,,S.....S::*.@@@%%%%@?%%#+++++%%%?S@@@@@.%.,@@...
      @@@@@@@@@@@:,,?.%%%::::@@@...%.@?.%.++++.+%%%%.@@@@..++@@@@@
      @@@@@@@@@@S,.%%.:,,,,,S@@@@@.?@@+SS,S..........@@@@@,@@@@@@@
      @@@@@@@@@@@+S...++.,,:@@@@@@@@@@@@@@@%....SSS+SS@@@@@@@@@@@@

      You got me!
```


You can also catch pokemon in your python applications. If you are going to be generating many, it is recommended to load the database once and provide it to the function, otherwise it will be loaded each time.


```
      from pokemon.master import catch_em_all, get_pokemon

      pokemons = catch_em_all()
      catch = get_pokemon(pokemons=pokemons)

```

I hope that you enjoy <a href="https://github.com/vsoch/pokemon-ascii" target="_blank">pokemon-ascii</a> as much as I did making it!
