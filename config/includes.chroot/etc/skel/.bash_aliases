alias ll='ls -alF'
alias ..='cd ..'
alias serial='ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null'
PS1='\[\e[38;5;179m\]\u\[\e[0m\]@\[\e[38;5;108m\]vibeos\[\e[0m\]:\[\e[38;5;75m\]\w\[\e[0m\] \$ '
if [ -t 1 ] && [ -z "$VIBEOS_GREETED" ]; then
  export VIBEOS_GREETED=1
  echo "VibeOS: run vibeos-tools to see what is installed. Starter projects are in ~/Engineering."
fi
