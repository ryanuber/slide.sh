slide.sh
========

Spend less time making slides

![""](https://raw.githubusercontent.com/ryanuber/slide.sh/master/examples/demo.gif)

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

Secondarily, `slide.sh` is an experiment in feature density vs. code footprint.
Complex conditions, pattern matching, string slicing, etc. are all done in the
most terse way possible while remaining readable by humans. This isn't to say
that this is a superior style, but rather a way of learning the bash shell's
built-ins deeply in a real way.

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
* Structured "decks" using directories of files.

Usage
-----

There are two functions provided by this library. Each has a different scope:

```
slide <optional message>
```

This command displays a single slide of text. The optional message is displayed
at the bottom of the screen in place of the default, which explains controls.
This command takes slide content from STDIN, so you can pipe slides into it or
use a heredoc for a better inline UX. It is typical to make many calls to
`slide` from within the same file to simulate a slide "deck", displaying one
after the other.

The exit code from `slide` represents the character which was entered on the
keyboard at exit time. Specifically:

    * `0`: Enter, or an unrecognized character.
    * `255`: Backspace
    * `1..254`: Typed number followed by the Enter key.

Typically the return code is ignored by the caller, but it can be used by other
programs to provide navigation if desired (see the `deck` command, for example).

```
deck <directory of *.slide files>
```

The `deck` command is a very simple wrapper over the `slide` command. It looks
at the given directory for files ending in `.slide`, and composes a slide "deck"
using their contents, one file per slide. There are a few important things to
note when using this command:

* Each slide file is passed through the shell for evaluation. This allows you
  to continue using command or variable expansion in the same exact format you
  normally would with slide.sh.
* All usual slide.sh markup is supported, so you can still do, for example,
  `!!center` to get centered text within a slide file.
* Slide numbers (for the slide index at the bottom of the display) are counted
  at the time the `deck` command is run. Any changes to the files in the given
  directory will cause undefined behavior.
* Slides are loaded in lexical order. To order slides, rename them so the sort
  in the order you desire.
* Slide navigation supports 254 slides at the max.

Use Cases
---------

Some useful things I've done with slide.sh / can think of for it:

* Demo REST API calls using cURL
* Demo command-line tool functionality
* Write some markdown-style slides for basic presentations
* Share slides with people in a `screen` session

Requirements
------------

* A bash shell
* `tput`

Examples
--------

The above demo was created from one of the demos in this repository. You can
find examples of how to use slide.sh in the [examples](examples) folder.
