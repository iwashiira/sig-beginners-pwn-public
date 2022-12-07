if [ $# -eq 0 ]; then
echo "Argument is required [on: 'y', off: 'n']"
exit 0
fi
if [ $1 == 'y' ]; then
echo 2 | sudo tee /proc/sys/kernel/randomize_va_space
echo "ASLR is on"
elif [ $1 == 'n' ]; then
echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
echo "ASLR is off"
else
echo "Invalid argument"
fi
