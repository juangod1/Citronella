if [ -f "$2.c" ]; then
    rm "$2.c";
fi
touch "$2.c";
cat $1 | ./Citronella >> "$2.c";
gcc "$2.c" -o $2
