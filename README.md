# TextToShapeMaker

Swift Package that has a function Executor.execute

Converts text like "MiCHAEL:KAORi,MICHAEl:lISA" into a shape.

```
  .      
  K      
  A      
  O      
  R    . 
.MICHAEL.
  .    I 
       S 
       A 
       . 
```

The string which is a CSV is split into an array of strings

let textArray = ["MiCHAEL:KAORi","MICHAEl:lISA"]

Then we convert them into an array of instructions:

let instructions = [
    {
        text: "MiCHAEL:KAORi",
        fromWord: "MICHAEL",
        fromPos: 1,
        toWord: "KAORI",
        toPos: 4,
        isValid: .success,
    },
    {
        text: "MICHAEl:lISA",
        fromWord: "MICHAEL",
        fromPos: 6,
        toWord: "LISA",
        toPos: 0,
        isValid: .success
    }
]

In this stage the system can detect if the instruction is success or one of these errors:

* sameWord - The user entered exactly the same word on both sides of the : character
* interlockNotFound - A word must have one and only one lowercase character to define the interlock position.  If there are no lowercase or more than one lowercase character.
* interlockNotMatching - The lowercase letter in the left word is not same letter as in right word.
* wordSeparatorError - Detected when instruction is not in the form of WORD1:WORD2 
    
We run the instructions through the `InstructionSequencer` which makes sure that these instructions are in the correct order.

We then create placements

```
let placements = [
    {
        word: "MICHAEL",
        isHorizontal: true,
        x: 0,
        y: 0
    },
    {
        word: "KAORI",
        isHorizontal: false,
        x: 1,
        y: -4
    },
    {
        word: "LISA",
        isHorizontal: false,
        x: 6,
        y: 0
    }
]
```

And then through the placements comes the shape which is what we see in the shape above but also contains

```
{
    text: "This is what we see above and the shape that the thing appears as",
    score: 38,
    width: 9,
    height: 10
    placements: [
        {
            word: "MICHAEL",
            isHorizontal: true,
            x: 0,
            y: 5
        },
        {
            word: "KAORI",
            isHorizontal: false,
            x: 2,
            y: 0
        },
        {
            word: "LISA",
            isHorizontal: false,
            x: 7,
            y: 4
        }
    ]
}
```
The placements have been translated so that the first position is 0,0 and we also add the . at the beginning and end of words.


Once we have converted everything it makes a ShapeModel which includes:

* score - crozzle estimate of worth of the shape
* width - width of the shape including the blocking characters at ends of words
* height - height of the shape including the blocking characters at ends of words
* placements - a list of placements which include {word, x, y, isHorizontal}
* text - shape as it would be rendered crossword puzzle style

If the text appears with a # character then the shape is invalid and will have a score of 0


## Rotating Shape

It is possible to rotate a shape by putting ! at the start of the shape

### "MiCHAEL:KAORi" produces

```
  .      
  K      
  A      
  O      
  R      
.MICHAEL.
  .      
```

### "!MiCHAEL:KAORi" 

Because it has ! at the beginning then it swaps the first instruction around and then removes all ! from the string so it transforms to KAORi:MiCHAEL
``` 
     . 
     M 
.KAORI.
     C 
     H 
     A 
     E 
     L 
     . 
```

### What Rotate Means
For the first instruction, the left word is going to be placed horizontally and the right word will be placed vertically.

You can see then that a rotated shape is exactly equivalent to the shape that was not rotated.

Granted it looks totally different but the information it stores in itself is identical.

So when we merge two shapes together often we have to rotate one of the shapes to make it connect to the other end of the merge.

### Computational Waste

So we can see that every shape has a rotated form of the same shape depending on what word started off the shape.

This computational waste occurs if we have a square shape.  Like this

```
 . .
.ABC.
 D E
.FGH.
 . .
```

In graph theory this is called a cycle.

So all of these shapes produce the exact same result
* "ABc:cEH,CEh:FGh,fGH:ADf"
* "CEh:FGh,fGH:ADf,aDF:aBC"
* "fGH:ADf,aDF:aBC,ABc:cEH"
* "aDF:aBC,ABc:cEH,CEh:FGh"
and all of these are just starting at one position and rotating clockwise.  There is also counter clockwise and a few other ways also.

So coming up with a shape like a square can produce a lot of combinations.

And also a rotated square looks like this

```
 . .
.ADF.
 B G 
.CEH.
```

So this doubles the amount of paths that will reach the same shape combination.

So based on this massive amount of redundant solutions, we generate all square shapes and have their duplicates, their rotated versions removed.

### Word Position Duplication

So we know that the first instruction decides the first word that is going to be horizontal and that handles rotates.

But its true that on the second instruction "ADf:fGH,FGh:CEh" is equivalent to "ADf:fGH,CEh:FGh"

So in the second position "FGh:CEh" is equal to "CEh:FGh".

So much duplication so one idea is that the left word is always higher in the sequence to the right word.  We can implement this if all words are coming from a known sequence of words.

And if that happens we can even just reference the position of the word in the sequence.  Not as easy to do as a human to pick so we wont go down that method in this discussion.  Ours is an easy way for a person to create any shape by adding a string to an input box.

# Merging

We can tackle merging if we add a plus sign

So merging is ShapeA+ShapeB

We take the instructions that creates a shape and add that to the instructions that creates another shape.

But we would have to change the order of the instruction sequence for the second shape and we might have to remove duplicates.

If all instructions are duplicates of the original shape we are starting from then the merge is really a subset of the original shape and so its not really a merge.

If there are no common words between shapes then a merge is not possible either.

In the winning game from 9005 we see two shapes merged together

```
      .  
      O  
     .P  
    .DUO.
.CHORUS. 
     E.  
     T   
     .   	
```
is merged with	

```
     .    
    .T    
.TENOR.   
   .PINZA.
  .DUO.   
    S.    
    .    
```
to form
```
       .    
      .T    
  .TENOR.   
     .PINZA.
    .DUO.   
.CHORUS.    
     E.     
     T      
     .      
```

We can go further and breaking a winning game into shapes, collecting all the interlocks for each shape and then merging all shapes

Here is the game 8612 which is tested within `ExecutorTests`

nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn + 
NAZAReTH:eVE,NAZARETh:hOLLY,BeLLS:EVe,BELlS:HOlLY + 
JOy:HOLLy + 
jOY:jELLY,HAZElNUT:JElLY,HAZELNUt:StAR + 
HAzELNUT:AzURE,HAZElNUT:JElLY,MErRY:AZUrE,MERRy:JELLy + 
hAZELNUT:hYMN,HAzELNUT:AzURE,mERRY:HYmN,MErRY:AZUrE + 
TURKEy:HyMN + 
TuRKEY:SAuCE + 
tOYS:tOAST,TOYs:sAUCE,tREE:TOASt,TREe:SAUCe + 
TOyS:FAMILy + 
INn:HYMn + 
TURkEY:PORk + 
WHiTE:FAMiLY + 
wHITE:SNOw + 
WHITe:CAKe

It produces this shape, which is the winning game:

```
 . . . . .  . .  
 S F C.NAZARETH. 
 N A A U I  V O  
 O M K T O.BELLS.
.WHITE.SING.. L  
 . L..P. ...JOY. 
.TOYS.O . A E .S 
 O .A R.HAZELNUT.
 A.TURKEY.U L  A 
 S  C ..MERRY. R 
.TREE.INN.E .  . 
 .  .   . .      
 ```
 
 So the merge works by having all instructions in a collection and starting with the first instruction, picking subsequent instructions that can connect with what is already there. If picked then it is removed from the todo list and added to the done list. If we find an instruction that is redundant then it is removed from the todo list also.
 
 We will eventually find there are no more instructions that can connect with the done list.
 
 If there are still instructions to do then we return a false meaning we could not process everything.  But if the todo list is empty then we return true.
 
 We have the option of providing just the text, or providing the InstructionModels that are then used to create the shape.
 
 
 If we pass the 8612 game to the InstructionSequencer as can be seen in `InstructionSequencerTests.test_8612` we can see the contatinated output which is a lot shorter because we have removed the redundant instructions.
 
 nAZARETH:nUTS,NAzARETH:zION,NUTs:sING,NAZAReTH:eVE,NAZARETh:hOLLY,EVe:BeLLS,HOLLy:JOy,jOY:jELLY,JElLY:HAZElNUT,HAZELNUt:StAR,HAzELNUT:AzURE,AZUrE:MErRY,hAZELNUT:hYMN,HyMN:TURKEy,TuRKEY:SAuCE,sAUCE:TOYs,tOYS:tOAST,TOASt:tREE,TOyS:FAMILy,HYMn:INn,TURkEY:PORk,FAMiLY:WHiTE,wHITE:SNOw,WHITe:CAKe

