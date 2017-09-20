---
title: "My Gum Chewing Algorithm :P"
date: 2010-11-27 11:50:28
tags:
  algorithm
  code
  fun
  gum
---


I was writing to a friend and somehow got into the topic of chewing gum, something that I’m very fond of. Matter of fact, I have a very methodical way of consuming my favorite three flavors, Orbit Cinnamon, Trident Strawberry, and Extra Watermelon, while I’m working busily away. So instead of writing it out in words, I decided to write a script in faux code. It was fun! And mostly for it’s preservation so that I can find it in X years down the road, here it is!

<span style="color: #008000;">% We start out with zero pieces of gum, and nothing being chewed.</span>

% The order keeps track of my special order of chewing, to be cycled through, 1 through 5  
 pieceCount = 0;  
 piecesLeft = 7; <span style="color: #008000;">% we start with 7 pieces</span>  
 chewing={}; <span style="color: #008000;">% we start chewing nothing</span>  
 order=1; <span style="color: #008000;">% start with order 1</span>  
 while (piecesLeft > 0)  
<span style="color: #008000;">% Always spit out gum when we have 2 pieces that have lost flavor:</span>  
 if ((pieceCount == 2) && (lostflavor(chewing)==’true’)  
 spit(chewing);  
<span style="color: #008000;">% Or spit if we have one extra watermelon piece that has lost flavor</span>  
 elseif((pieceCount == 1) && (lostflavor(chewing)==’true) && (chewing==’extra(1)’||’extra(2)’))  
 spit(chewing);  
 else  
 order = consume(order);  
 end  
<span style="color: #008000;">% Here is the function to chew the gum based on our current order</span>  
 function consume(order_number)  
 switch order:  
<span style="color: #008000;">% Start with one strawberry piece, and chew until it’s no good</span>  
 case 1: eat(strawberry(1))  
 while(lostflavor(strawberry(1))~=’true’)  
 chew()  
 end  
<span style="color: #008000;">% When it loses flavor, add an extra watermelon piece</span>  
 add(extra(1),strawberry(1))  
 while(lostflavor(strawberry(1),extra(1))~=’true’)  
 chew()  
 end  
 return 2;  
<span style="color: #008000;">% Then eat the last extra piece, and chew until it’s no good</span>  
 case 2: eat(extra(2))  
 while(lostflavor(extra(2))~=’true’)  
 chew()  
 end  
 return 3;  
<span style="color: #008000;">% Eat both strawberry pieces together, because they are small!</span>  
 case 3: eat({strawberry(2),strawberry(3)})  
 while(lostflavor({strawberry(2),strawberry(3)})~=’true’)  
 chew()  
 end  
 return 4;  
<span style="color: #008000;">% Grand finale is two cinnamon pieces!</span>  
 case 4: eat({orbit(1),orbit(2))  
 while(lostflavor({orbit(1),orbit(2)})~=’true’)  
 chew()  
 end  
 return 5;  
 case 5;  
 fprintf(‘%s\n’,’We’ve finished all of our gum! Replenish supply and start over’)  
 exit;  
 end  
 end  
<span style="color: #008000;">% Function to eat gum</span>  
 function eat({gum})  
 nomnom(gum);  
 piecesLeft=piecesLeft-size(gum);  
 chewing=gum;  
 end  
<span style="color: #008000;">% Function to spit out gum being chewed</span>  
 function spit(tospit)  
 trash(tospit)  
 pieceCount = 0;  
 piecesLeft = piecesLeft -size(tospit);  
 chewing = {};  
 end  
 end  
 It kind of makes me want to try writing scripts for little things in life that are methodical like brushing your teeth, cooking, or running. It also makes me realize that people who design the machines and gadgets that we use in our everyday life actually DO think about these sorts of algorithms. That’s so cool! :O)


