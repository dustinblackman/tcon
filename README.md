![tcon](assets/banner.jpg)

A slightly lazy shell script to run parallel commands with tmux panes through a FIFO queue. This makes it super easy to run multiple jobs at the same time while monitoring progress. `tcon` uses [`tmux-xpanes`](https://github.com/greymd/tmux-xpanes#installation) under the hood, you can pass xpanes parameters to `tcon` after the concurrency limit to take full advantage of it.

## Usage

```sh
  # Echo a line and sleep afterwards with a concurrency of 4. `-x` is passed along to tmux-xpanes.
  seq 1 10 | (while read f; do echo "echo 'Sleeping for $f seconds' && sleep $f"; done;) | tcon 4 -x
```

## Installation

```
  curl -L https://raw.githubusercontent.com/dustinblackman/tcon/master/tcon.sh > /usr/local/bin/tcon
  chmod +x /usr/local/bin/tcon
```

## [License](./LICENSE)

MIT
