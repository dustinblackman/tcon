#!/bin/bash -e

child() {
  pipe="$1"

  while true; do
    if read line <$pipe; then
      if [[ "$line" == 'tcon-quit' ]]; then
        exit 0
      fi

      echo "$line"
      (eval "$line")
    fi
  done
}

run() {
  concurrency="$1"
  shift;

  echo "Starting up tmux panes with a concurrency of $concurrency"

  FIFO=$(mktemp)
  rm $FIFO
  mkfifo $FIFO

  commands=$(cat -)
  commands_count=$(echo "$commands" | wc -l | sed 's/ //g')

  seq 1 "$concurrency" | xpanes "$@" -c "tcon child $FIFO"

  count=0
  echo "$commands" | while read f; do
    count=$((count+1))
    echo "$f" > "$FIFO"
    echo "Running ${count}/${commands_count}: $f"
  done

  seq 1 "$concurrency" | while read f; do echo 'tcon-quit' > "$FIFO"; done;

  # Lazy cleanup.
  (sleep 2 && rm "$FIFO") &
}

if [[ "$1" == "child" ]]; then
  child "$2"
else
  run "$@"
fi
