cmd=(
    "aslr"
    "cargo"
    "checksec"
    "curl"
    "docker"
    "gcc"
    "gdb"
    "git"
    "nc"
    "node"
    "npm"
    "nvim"
    "one_gadget"
    "patchelf"
    "python3"
    "ropr"
    "rp++"
    "wget"
    "extract-vmlinux"
    "musl-gcc"
    "qemu-system-x86_64"
)

echo "Verify all the commands are installed"

for i in "${cmd[@]}"
do
    if ! [ -x "$(command -v ${i})" ]; then
        echo -e "\e[33mWarning: \e[m\e[35m${i}\e[m is not installed" >&2
    fi
done

pypkg=(
    "pathlib2"
    "ptrlib"
    "pwntools"
)

echo "Verify all python3 pkg are installed"

for i in "${pypkg[@]}"
do
    python3 -m pip show ${i} | grep -F package_name
done
