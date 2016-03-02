#!/bin/bash

# This is a basic example usage of slide.sh. You can use slide.sh as a library
# function, giving you free form to compose slides in whatever way your shell
# supports.

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
