#!/usr/bin/env bash

set -eu
set -o pipefail

ulimit -c
sudo bash -c "ulimit -c unlimited"
ulimit -c unlimited -H
ulimit -c unlimited -S
ulimit -c
ulimit -a -S
ulimit -a -H
cat /proc/sys/kernel/core_pattern || true
sysctl kernel.core_pattern
sudo service apport restart || true
echo '#!/usr/bin/env bash' > apport
echo '' >> apport
echo "echo yes >> $(pwd)/core" >> apport
chmod +x ./apport
#sudo cp apport /usr/share/apport/apport
sudo bash -c "chmod +x /usr/share/apport/apport"
sudo bash -c "cat /proc/sys/kernel/core_pattern" || true
# the below hits: 'bash: /proc/sys/kernel/core_pattern: Permission denied'
#sudo bash -c "echo \"core.%e.%p.%h.%t\" > /proc/sys/kernel/core_pattern" || true
sudo bash -c "cat /proc/sys/kernel/core_pattern" || true
RESULT=0
# Compile our demo program which will crash if
# the CRASH_PLEASE environment variable is set (to anything)
make
# Run the program to prompt a crash
# Note: we capture the return code of the program here and add
# `|| true` to ensure that travis continues past the crash
./test || true
RESULT=$(./test > ./output.txt)$? || true
cat ./output.txt
ls
ls /var/crash/ || true
cat /var/log/apport.log || true
if [[ ${RESULT} == 0 ]]; then echo "\\o/ our test worked without problems"; else echo "ruhroh test returned an errorcode of $RESULT"; fi;
# If the program returned an error code, now we check for a
# core file in the current working directory and dump the backtrace out
for i in $(find ./ -maxdepth 1 -name 'core*' -print); do gdb $(pwd)/test core* -ex "thread apply all bt" -ex "set pagination 0" -batch; done;
# now we should present travis with the original
# error code so the run cleanly stops
if [[ ${RESULT} != 0 ]]; then exit $RESULT ; fi;
