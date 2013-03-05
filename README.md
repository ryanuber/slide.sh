slide.sh
========

Example:

    #!/bin/bash
    . slide.sh
    slide <<EOF

            Save time making your slides with slide.sh

                    Ryan Uber <ru@ryanuber.com>
    EOF
    slide <<EOF

            Check this  out - I can type free-form text in here, or I can
            use backticks or dollar-parenthesis to execute commands inside
            of the slide!

            Today is $(date +%A)
    EOF
    slide <<EOF

            I can also use variables for repetetive information. Example:

            My current directory is $PWD
    EOF
    slide "End of slides - Press enter to quit" <<EOF

            ...And that's all you need to know!
    EOF
