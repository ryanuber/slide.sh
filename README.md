slide.sh
========

Example:

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

    Today is $(date +%A)
    EOF

    slide <<EOF
    !!center
    You can also use variables for repetetive information, like this:

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
