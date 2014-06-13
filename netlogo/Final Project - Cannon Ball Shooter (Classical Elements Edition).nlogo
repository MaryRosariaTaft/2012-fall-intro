breed [fires fire]; red
breed [ices ice]; blue
breed [airs air]; white
breed [earths earth]; green
breed [cannons cannon]

turtles-own [on-cannon same-color-neighbors]
globals [cannoncolor number-of-lines Score]

to setup
  ca
  set Score 20
  ask patches
    [set pcolor brown]
  set-default-shape turtles "circle"
  ask patches with [pycor >= (max-pycor - Number-of-Starting-Lines + 2)] ; This creates one fewer lines than called for in "Number-of-Starting-Lines."  When "Play" is clicked, the remaining line will appear.
    [sprout 1
      [ask turtles with [(who mod 4) = 0]
        [set breed fires
         set color 15]
       ask turtles with [(who mod 4) = 1]
        [set breed ices
         set color 97]
       ask turtles with [(who mod 4) = 2]
        [set breed airs
         set color 39]
       ask turtles with [(who mod 4) = 3]
        [set breed earths
         set color 52]
       set on-cannon false]]
   set number-of-lines Number-of-Starting-Lines
   crt 1
   [set breed cannons
    set size 5.5
    set heading 0
    set shape "cannon"
    setxy 0 min-pycor + 1
    set color gray]
  new-cannonball
end

to new-cannonball
  if count turtles-on patch 0 (min-pycor + 1) = 2 [stop]
  ask patch 0 (min-pycor + 1)
    [sprout 1
      [set on-cannon true
       setxy 0 min-pycor + 1
       set color one-of [15 97 39 52]]]
   ask turtles with [on-cannon = true]
     [if color = 15
       [set breed fires
        set cannoncolor 1]
      if color = 97
       [set breed ices
        set cannoncolor 2]
      if color = 39
       [set breed airs
        set cannoncolor 3]
      if color = 52
       [set breed earths
        set cannoncolor 4]]
   ask cannons
     [if cannoncolor = 1 [set color 15]
      if cannoncolor = 2 [set color 97]
      if cannoncolor = 3 [set color 39]
      if cannoncolor = 4 [set color 52]]
end

to face-mouse
  ask turtles-on patch 0 (min-pycor + 1)
   [facexy mouse-xcor mouse-ycor]
end

to update-connecting-neighbors
  ask turtles with [breed != cannons and pycor != (min-pycor + 1)]
   [if count turtles-on neighbors4 = 0 ; This is the line which results in the problem addressed in "Extending The Model."
     [die]
    set same-color-neighbors (count (turtles-on neighbors4) with [color = [color] of myself])]
end

to shoot
  ask turtles
    [if mouse-down? = true
      [if on-cannon = true
        [while [((abs xcor) + 1 >= max-pxcor) or (ycor + 1 >= max-pycor) or (not any? other turtles-on patch-ahead 1)]
          [wait .007 ; Note the reference.
           fd 1]
         setxy round xcor round ycor
         update-connecting-neighbors]
         if same-color-neighbors = 0
           [set on-cannon false]
      ask cannons [set color gray]]]
end

to score-bubbles [n]
  set Score Score + n
end

; The following four procedures deal with the deletion of groups of balls:
  

to break-bubbles ; Running this procedure causes the succeeding three procedures to be run.  It is called for under certain conditions in the code for "Play" (in the Interface) rather than within another procedure.
  ask (turtles-on neighbors4) with [color = [color] of myself]
   [break-neighbors
    if Graphics = true [break-graphics]
    score-bubbles 2
    die]
end

to break-neighbors
  if same-color-neighbors > 0
    [ask (turtles-on neighbors4) with [color = [color] of myself]
      [again
       if Graphics = true [break-graphics]
       score-bubbles 2
       die]]
end

to again
  if same-color-neighbors > 0
    [ask (turtles-on neighbors4) with [color = [color] of myself]
      [again-2
        if Graphics = true [break-graphics]
        score-bubbles 2
       die]]
end

to again-2
  if same-color-neighbors > 0
    [ask (turtles-on neighbors4) with [color = [color] of myself]
      [if Graphics = true [break-graphics]
       score-bubbles 2
       die]]
end

; The following two procedures don't work as written, but they may be helpful for the ambitious player when coding.  They are meant to run recursively.
; If either of these is fixed, the procedures "break-bubbles," "break-neighbors," "again," and "again-2" should be removed.

;to break-bubbles-1
;  ifelse ((count (turtles-on neighbors4) with [color = [color] of myself]) > 0)
;    [ifelse ((abs xcor) + 1 >= max-pxcor) or (ycor + 1 >= max-pycor)
;      [stop]
;      [ask (turtles-on neighbors4) with [color = [color] of myself]
;        [break-bubbles-1
;         die]]]
;    [stop]
;end

;to break-bubbles-2
;Note: To use this procedure, you must create a global variable called "dead-turtle," which signifies whether each turtle has already run "break-bubbles-2" and will die after recursion is complete.
;      Make sure to set "dead-turtle" false any time new turtles are created: in "setup" (after "sprout" and "crt"), in "new-cannonball," and in "continue" (after "sprout").
;      If you try to fix this, good luck!
;  ifelse ((abs xcor) + 1 >= max-pxcor) or (ycor + 1 >= max-pycor) or (dead-turtle = true)
;    [stop]
;    [ifelse ((count (turtles-on neighbors4) with [color = [color] of myself]) > 0) and on-cannon = true
;       [set dead-turtle true
;        ask (turtles-on neighbors4) with [color = [color] of myself]
;         [break-bubbles-2]]
;        [stop]]
;    ask turtles with [dead-turtle = true]
;      [die]
;end

to continue ; This creates a new line.
  score-bubbles -20
  ask turtles with [(breed != cannons) and (ycor != min-pycor + 1)]
    [set heading 0
     bk 1]
  ask patches with [pycor = max-pycor]
    [sprout 1
     [if who mod 4 = 0
       [set breed fires
        set color 15]
      if who mod 4 = 1
       [set breed ices
        set color 97]
      if who mod 4 = 2
       [set breed airs
        set color 39]
      if who mod 4 = 3
       [set breed earths
        set color 52]
      set on-cannon false]]
  set number-of-lines number-of-lines + 1
end

to break-graphics
  set size 2.5
  if breed = fires [set color yellow set shape "fire"] ; "Fire" might have to be imported from the Turtle Shapes Library.
  if breed = ices [set color blue set shape "drop"] ; "Drop" might have to be imported from the Turtle Shapes Library.
  if breed = airs [set color gray set shape "target"]
  if breed = earths [set color 31 set shape "plant"]
  wait .12
end

to lose
  ifelse user-yes-or-no? "You're a loser. Would you like to redeem yourself?"
     [setup]
     [display user-message "Okay, goodbye now."]
end

to game-over
  if number-of-lines > 15
    [ca
     set Score 0
     ask patches with [(pxcor + pycor) mod 2 = 0]
       [set plabel "Lose"]
     lose
     stop]
 if count turtles < 3
    [ca
     ask patches with [(pxcor + pycor) mod 2 = 0]
       [set plabel "Win"]
     display user-message "You're a winner!"
     stop]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
670
491
12
12
18.0
1
10
1
1
1
0
0
0
1
-12
12
-12
12
0
0
1
ticks
30.0

SLIDER
20
25
202
58
Number-of-Starting-Lines
Number-of-Starting-Lines
3
12
6
1
1
NIL
HORIZONTAL

BUTTON
33
215
186
252
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
40
274
178
307
Play
face-mouse\nupdate-connecting-neighbors\nshoot\nask turtles [if (same-color-neighbors > 0) and (on-cannon = true)\n          [break-bubbles\n           die]]\nask turtles [if on-cannon = true and (abs xcor = max-pxcor or ycor = max-pycor)\n[set heading (- heading) shoot]]\nevery Seconds-Per-Line [continue]\ngame-over
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
49
330
167
363
Reload
new-cannonball
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

SLIDER
21
77
203
110
Seconds-Per-Line
Seconds-Per-Line
10
60
40
10
1
NIL
HORIZONTAL

SWITCH
55
128
162
161
Graphics
Graphics
0
1
-1000

MONITOR
82
407
139
452
NIL
Score
0
1
11

@#$#@#$#@
## WHAT IS IT?

Mary Taft – Period 9
Maria Vasilkin – Period 9
Jessie Zhan – Period 9
Cannon Ball Shooter: Classical Elements Edition

## HOW IT WORKS

The player shoots a cannon ball out of a cannon towards rows of balls that are randomly colored either red, blue, white, or green.  If the cannon ball hits another ball of the same color, all of the balls in the group of that color within a radius of three from the cannon ball are deleted from the screen; for each ball you pop, you gain two points.  Otherwise, the cannon ball will stick to the other balls; no points will be deducted.  (However, if you have bad aim and hit an empty wall, the game will freeze!)  To win, clear all the balls on the screen, but work fast – another line is added to the game periodically, and each time, you'll lose 20 points.  If you exceed 15 lines on the screen, you lose!

## HOW TO USE IT

Choose the number of lines with which you want your game to start using the "Number-of-Starting-Lines" slider.  (Please read "NetLogo Features" to avoid confusion regarding the aforementioned slider.)  Choose the frequency of the addition of new lines using the "Seconds-Per-Line" slider.  Choose whether you want to use graphics using the "Graphics" switch.  (We highly recommend using graphics, but they are a bit more time-consuming.  However, you might have to import the shapes "Fire" and "Drop" from the Turtle Shapes Library.)  The "Setup" button prepares the game, and the "Play" button starts the game.  You can tell the color of the ball which you're going to shoot by the color of the cannon, and the direction in which you're shooting by the direction in which the cannon is pointed.  To shoot the ball, point your mouse in the direction you want to aim and click when you're ready.  Reload your cannon between shots by clicking the 'A' button on your keyboard.

Note: If you stop in the middle of game to start a new one, unclick "Play" before clicking "Setup" again.

## THINGS TO NOTICE

First, the basics: be aware of your score in the monitor, make sure you've clicked "Play" when you begin, and check the color of your cannon to see whether you need to reload (it will be gray if you do).

The colors of the balls are based on the Greek classical elements: fire, water, air, and earth.  The graphic which appears when a ball is deleted corresponds to the element of that ball.  Also, notice this game’s quirks! (See “Extending the Model” for more information.)

Make sure to open the "Code" tab and read the comment in "shoot."


## THINGS TO TRY

We suggest that the first time you play, you begin with a low number of lines and a long time between new lines.  At some point, after you've improved, try setting the number of starting lines to the highest value (12) and/or setting the seconds per line to the lowest value (10). You probably won’t win, but you can feel like an expert for a while.

## EXTENDING THE MODEL

We believe that the best thing about this model is that it gives the player the opportunity to try coding in NetLogo!  There are an abundance of glitches which will provide the player with plenty of coding experience.  These include the following:
- If a group of two or more balls is stranded (i.e. detached from the group of balls which are connected to the wall), it remains there floating.
- Sometimes, a cannon ball will land between patches, and the program will freeze.
- If a cannon ball hits another ball on its direct corner, the cannon ball gets deleted.  (This problem is resultant of the conditions in "update-connecting-neighbors.")

There are also a couple features which the player may dislike and would like to change.
- As mentioned in "How It Works," the player is encountered with a frozen program if a cannon ball hits an empty wall.  (To unfreeze, go into the Code tab and make a temporary change in any of the procedures called for in "Play."  For example, open the Code, go to "shoot," add an unnecessary space between the words "to" and "shoot," then backspace.  The Interface will thence allow the "Play" button to be clicked again.)  We deemed that feature good incentive for the player to shoot his cannonballs strategically, but he may add code to make the cannon ball stick to or bounce off the walls if he so wishes.
- Our version of this game only eliminates a limited radius of each group of like-colored balls, so that the player – whom we know is highly skilled – has more of a challenge.  Also, the beauty of the deletion graphics isn't too overwhelming! However, in most versions of the game, when a group of like-colored balls is hit with a cannon ball, it is deleted in its entirety.  We've provided two blocks of code (called "break-bubbles-1" and "break-bubbles-2") as comments in the coding to aid in this endeavor, but please read the comments preceeding them before beginning.

## NETLOGO FEATURES

When you originally set the "Number-of-Starting-Lines" slider, "Setup" creates one line fewer.  (So, it will initially appear that we can't count.)  However, part of the "Play" procedure includes shifting the lines down periodically, and as soon as you click "Play" it adds a line to the screen, which makes the number of lines equal to the number on the slider.  Similarly, when you originally click "Setup," your score will automatically be 20.  Unfortunately for you, it is a fleeting moment of glory, and your score will return to 0 when you begin to play.  (Luckily, if you read this before playing, you'll be prepared, and spared of some agony.)

## RELATED MODELS

The NetLogo Models Library does not have a game similar to this one, but if you're skilled at this, you might like to check out Tetris.  It also requires patience and attention to time.

## CREDITS AND REFERENCES

Our game is loosely based on this one: http://www.bubblegame.org/
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

cannon
true
0
Polygon -7500403 true true 165 0 165 15 180 150 195 165 195 180 180 195 165 225 135 225 120 195 105 180 105 165 120 150 135 15 135 0
Line -16777216 false 120 150 180 150
Line -16777216 false 120 195 180 195
Line -16777216 false 165 15 135 15
Polygon -16777216 false false 165 0 135 0 135 15 120 150 105 165 105 180 120 195 135 225 165 225 180 195 195 180 195 165 180 150 165 15

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

drop
false
0
Circle -7500403 true true 73 133 152
Polygon -7500403 true true 219 181 205 152 185 120 174 95 163 64 156 37 149 7 147 166
Polygon -7500403 true true 79 182 95 152 115 120 126 95 137 64 144 37 150 6 154 165

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
