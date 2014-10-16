## travis-coredump

On travis you might see a cryptic error like:

    /home/travis/build.sh: line 41:  2300 Segmentation fault

Or:

    *** glibc detected *** ./test: double free or corruption (top): ***

Yay, your app segfaulted or hit a double-free. And you can't reproduce locally. And running your program in the gdb interpreter won't work on a remote machine. What now?

You have come to the right place.

This repo contains a demo of:

 - How to enable coredumps for linux (`ulimit -c unlimited`)
 - A c++ program that will crash when run leading to a core dump
 - How to programatically generate a backtrace from the coredump so you can see it in the travis logs

See the `.travis.yml` for detailed instructions.

### Other platforms

If you are on OS X, you don't need to worry about these steps, just look inside:

    ~/Library/Logs/DiagnosticReports/

And a backtrace should be present for any program that just crashed.

If you are on Windows, let me know if you have tips on generating backtraces for crashes on the command line.