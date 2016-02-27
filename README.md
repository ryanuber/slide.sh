slide.sh
========

Spend less time making slides
<p align="center">
  <img src="/slide_demo.gif">
</p>

What is it?
-----------

slide.sh is a small, basic, kludgy, hackish, ghetto slide maker that
will execute entirely inside of your shell.

There are no graphics, no transitions or effects, no cool line
drawing abilities, or anything like that. Seriously bro, its a shell
script.

Purpose
-------

`slide.sh` began as an experiment in what the bash shell is capable of all on
its own, and attempts to do something cool without assuming that there are a
slew of commands at your disposal. There only requirement outside of bash itself
is the `tput` command, since bash doesn't provide the needed capabilities to
move the cursor about the screen freely.

Functionality
-------------

What slide.sh provides is the ability to show simulated pages of ASCII text
inside of your terminal. An advantage to this is that you, as some sort
of programmer, won't have to take a bunch of screen caps or copy /
paste text into some full-featured slide creation program to demo the
core functionality of your executable program in a clean and organized
way while notating certain things and controlling the flow of your
presentation.

Features
--------

* Pre-formatted text will render exactly as it was produced
* Text centering for writing titles, page markers, etc.
* Slide pausing to help demonstrate multi-step processes
* Slide separators (horizontal rule)
* Current slide/total slides (ratio and percentage completed)
* Animation for loading slides

Uses
----

Some useful things I've done with slide.sh / can think of for it:

* Demo REST API calls using cURL
* Demo command-line tool functionality
* Write some markdown-style slides for basic presentations
* Share slides with people in a `screen` session

Requirements
------------

* A bash shell
* `tput`

Example
-------

The above demo was created from the following shell script, which just
sources slide.sh and then makes some slides.

```bash
#!/bin/bash
source ./slide.sh

slide <<EOF
!!center
<green>slide.sh<end>

Spend less time making slides
https://github.com/ryanuber/slide.sh
EOF

slide <<EOF
By default, text appears exactly as you entered it.
EOF

slide <<EOF
!!center
Centering Text

In any of your slides, you can insert a line that reads '!!center'. This
will cause text in the following lines to be centered.

!!nocenter
You can use '!!nocenter' at any time to stop centering lines
EOF

slide <<EOF
!!center
You can use backticks or dollar-parenthesis to execute commands inside
of the slide, like this:

Today is \$(date +%A)

evaluates to...

Today is $(date +%A)
EOF

slide <<EOF
!!center
You can also use variables for repetetive information, like this:

The current working directory is \$PWD

evaluates to...

The current working directory is $PWD
EOF

slide 'Check out this custom action message' <<EOF
!!center
You can pass a string argument to 'slide' to define a custom action message,
rather than the default 'next slide' message.
EOF

slide <<EOF
You can add pauses inside of each slide for demonstrating things. You can
advance slide rendering by pressing return. For example, in this slide, there
should be a pause immediately after this sentence.
!!pause
Did it pause? Cool! It should pause one more time following this sentence.
!!pause
You can use !!pause as many times as you'd like.
EOF

slide <<EOF
!!center
Separators

You can separate parts of a slide by using '!!sep' on a line of its own.
!!sep
It is useful for packing multiple thoughts or ideas into a single slide.
!!sep
You could also use it to create a separated header at the top of each slide.
You can add as many separators as you want.
EOF

slide <<EOF
!!center
<red>C<green>o<yellow>l<blue>o<purple>r<end>

slide.sh supports a number of color options:
!!nocenter
    <red>red<end>
    <green>green<end>
    <blue>blue<end>
    <cyan>cyan<end>
    <yellow>yellow<end>
    <purple>purple<end>

!!center
!!nocolor
You can use !!nocolor to disable colors, and !!color to re-enable it later.

Colors are invoked using "<colorname>". So for example, <red> would give you red
text until the next <colorname> or <end> is encountered.
EOF

slide 'Only one more slide to go! ->' <<EOF
!!center

<cyan>Putting it all together<end>
<green>!!sep<end>

This slide demonstrates all of the functionality working together.
!!pause


I'll show you the time from a few different places around the world.
!!pause
!!nocenter

!!sep
   California      $(TZ=America/Los_Angeles date)
   Panama          $(TZ=America/Panama date)
   Virgin Islands  $(TZ=America/Virgin date)
   Tahiti          $(TZ=Pacific/Tahiti date)
   Athens          $(TZ=Europe/Athens date)
!!sep

!!pause

!!center
Putting slides together is super-fast and easy!
EOF

slide 'End of slides - Press enter to quit' <<EOF
!!center
...And that's all you need to know!
EOF
```
