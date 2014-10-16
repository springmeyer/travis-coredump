## travis-coredump

On travis you might see a cryptic error like:

    /home/travis/build.sh: line 41:  2300 Segmentation fault

Yay, your app segfaulted or hit a double-free. But you can't reproduce locally. What now?

Locally you would just run your app in the interactive gdb interpreter but that's not viable on a remote machine, so instead what you want to do is programatically generate a backtrace and print it to the travis logs so you can study the details.

So, you have come to the right place.

This repo contains a demo of:

 - How to enable coredumps for linux (`ulimit -c unlimited`)
 - A c++ program that will crash when run
 - How to use gdb to generate a backtrace from the core file on the command line

See the `.travis.yml` for detailed instructions.

### Other platforms

If you are on OS X, you don't need to worry about these steps, just look inside:

    ~/Library/Logs/DiagnosticReports/

And a backtrace should be present for any program that just crashed.

If you are on Windows, let me know if you have tips on generating backtraces for crashes on the command line.