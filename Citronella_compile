if [ -z "$1" ]; then
  echo 'ARGUMENTS ERROR: Program should be run as \n./Citronella_compile.sh file.Cit executable_name'
  exit
fi

if [ -z "$2" ]; then
  echo 'ARGUMENTS ERROR: Program should be run as \n./Citronella_compile.sh file.Cit executable_name'
  exit
fi

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
