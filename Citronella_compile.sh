if [ -f "$2.c" ]; then
    rm "$2.c";
fi
touch "$2.c";

cat $1 | if ./Citronella >> "$2.c"; then
  gcc "$2.c" -o $2
  rm "$2.c"
else
    echo "Citronella compilation failed"
fi
