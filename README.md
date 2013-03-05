slide.sh
========

Example:

    #!/bin/bash
    . slide.sh

    slide --center <<EOF
    Save time making your slides with slide.sh
    Ryan Uber <ru@ryanuber.com>
    EOF

    slide --center <<EOF
    You can use the '--center' option to center the lines of text in the slide.
    EOF

    slide --center 2 <<EOF
    While using '--center', you can optionally specify the number of lines to
    center. In this case, only the first 2 lines should be centered.
    This line should not be centered.
    EOF

    slide <<EOF
    Without --center, lines of text appear exactly as you define them.
    EOF

    slide --center <<EOF
    You can use backticks or dollar-parenthesis to execute commands inside
    of the slide, like this:

    Today is $(date +%d)
    EOF

    slide --center <<EOF
    I can also use variables for repetetive information. Example:
    My current directory is $PWD
    EOF

    slide --center <<EOF
    You can press 'q' at any time to quit gracefully out of the slide deck
    EOF

    slide --center --message "Check out this custom action message" <<EOF
    You can use the '--message' option to specify a custom action message,
    rather than the default 'next slide' message.
    EOF

    slide --center --message "End of slides - Press enter to quit" <<EOF
    ...And that's all you need to know!
    EOF
