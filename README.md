slide.sh
========

Spend less time making slides
-----------------------------

![""](http://ryanuber.github.com/slide.sh/slide_demo.gif "")

What is it?
-----------

slide.sh is a small, basic, kludgy, hackish, ghetto slide maker that
will execute entirely inside of your shell.

There are no graphics, no transitions or effects, no cool line
drawing abilities, or anything like that. Seriously bro, its a shell
script.

Purpose
-------

What slide.sh provides is the ability to show simulated pages of ASCII text
inside of your terminal. An advantage to this is that you, as some sort
of programmer, won't have to take a bunch of screen caps or copy /
paste text into some full-featured slide creation program to demo the
core functionality of your executable program in a clean and organized
way while notating certain things and controlling the flow of your
presentation.

Uses
----

Some useful things I've done with slide.sh / can think of for it:

* Demo REST API calls using cURL
* Demo command-line tool functionality
* Write some markdown-style slides for basic presentations

Example
-------

The above demo was created from the following shell script, which just
sources slide.sh and then makes some slides.

    #!/bin/bash
    . slide.sh
    
    slide <<EOF
    !!center
    slide.sh
    Spend less time making slides
    https://github.com/ryanuber/slide.sh
    EOF
    
    slide <<EOF
    By default, lines of text appear exactly as you define them.
    EOF
    
    slide <<EOF
    !!center
    Centering Text
    
    In any of your slides, you can insert a line that reads '!!center'. This
    will cause text in the following lines to be centered.
    
    !!nocenter
    You can use '!!nocenter' at any time to stop centering lines, even in the
    middle of a slide.
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
    
    slide <<EOF
    !!center
    You can press 'q' at any time to quit gracefully out of the slide deck
    EOF
    
    slide "Check out this custom action message" <<EOF
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
    
    slide "End of slides - Press enter to quit" <<EOF
    !!center
    ...And that's all you need to know!
    EOF
