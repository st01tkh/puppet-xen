#! /usr/bin/env bash

function add_auto_manual_to_each_xenbr() {
  local path; path="$1"
  [ ! -e "$path" ] && echo "Error: no such file '$path' or it's not a dir" && return 1
  grep -R -v '^#' "$path" | sed -nr 's/^.*(xenbr[0-9]+).*$/\1/p' | sort | uniq \
    | sed 's/xenbr/eth/' \
    | while read line; do
      grep -q -F "auto $line" "$path" || echo "auto $line" >> "$path"
      grep -q -F "iface $line inet manual" "$path" || echo "iface $line inet manual" >> "$path"
    done
}

function get_stanzas() {
    echo "iface mapping auto allow- source"
}

function add_bridge_ports_to_each_xenbr() {
  local path; path="$1"
  local ifnum; 
  local ifport;
  [ ! -e "$path" ] && echo "Error: no such file '$path' or it's not a dir" && return 1
  grep -R -v '^#' "$path" | sed -nr 's/^\W*iface\W+(xenbr[0-9]+).*$/\1/p' | sort | uniq \
    | while read line; do
      ifnum="$(echo "$line" | sed -nr 's/^.*([0-9]+)$/\1/p')"
      ifport="eth$ifnum"
      sed -i -r "/iface $line/a \ \ \ \ bridge_ports $ifport" "$path" 
  done
}

function add_bridge_ports_to_each_xenbr_in_dir() {
  local dir; dir="$1"
  local find_cmd; find_cmd="find '$dir' -mindepth 1 -maxdepth 1 -type f"
  [ -n "$2" ] && find_cmd="$find_cmd -name '$2'"
  #echo "find_cmd: $find_cmd"
  [ ! -d "$dir" ] && echo "Error: no such dir '$dir' or it's not a dir" && return 1
  local f; eval "$find_cmd" | while read f; do
    add_bridge_ports_to_each_xenbr "$f"
  done
}

function add_auto_manual_to_each_xenbr_in_dir() {
  local dir; dir="$1"
  local find_cmd; find_cmd="find '$dir' -mindepth 1 -maxdepth 1 -type f"
  [ -n "$2" ] && find_cmd="$find_cmd -name '$2'"
  #echo "find_cmd: $find_cmd"
  [ ! -d "$dir" ] && echo "Error: no such dir '$dir' or it's not a dir" && return 1
  local f; eval "$find_cmd" | while read f; do
    add_auto_manual_to_each_xenbr "$f"
  done
}

function add_auto_manual_to_each_xenbr_in_interfaces() {
  add_auto_manual_to_each_xenbr '/etc/network/interfaces'
}

function add_auto_manual_to_each_xenbr_in_interfaces_d() {
  add_auto_manual_to_each_xenbr_in_dir '/etc/network/interfaces.d' '*.cfg'
}

function add_bridge_ports_to_each_xenbr_in_interfaces() {
  add_bridge_ports_to_each_xenbr '/etc/network/interfaces'
}

function add_bridge_ports_to_each_xenbr_in_interfaces_d() {
  add_bridge_ports_to_each_xenbr_in_dir '/etc/network/interfaces.d' '*.cfg'
}

self_fpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
exec_fpath="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
if [ "$self_fpath" = "$exec_fpath" ]; then
  case "$1" in
    aamf)
      add_auto_manual_to_each_xenbr $2
      ;;
    aamd)
      add_auto_manual_to_each_xenbr_in_dir $2 $3
      ;;
    aamif)
      add_auto_manual_to_each_xenbr_in_interfaces
      ;;
    aamid)
      add_auto_manual_to_each_xenbr_in_interfaces_d
      ;;
    aamifd)
      add_auto_manual_to_each_xenbr_in_interfaces && add_auto_manual_to_each_xenbr_in_interfaces_d
      ;;
    abpf)
      add_bridge_ports_to_each_xenbr $2
      ;;
    abpd)
      add_bridge_ports_to_each_xenbr_in_dir $2 $3
      ;;
    abpif)
      add_bridge_ports_to_each_xenbr_in_interfaces
      ;;
    abpid)
      add_bridge_ports_to_each_xenbr_in_interfaces_d
      ;;
    abpifd)
      add_bridge_ports_to_each_xenbr_in_interfaces && add_bridge_ports_to_each_xenbr_in_interfaces_d
      ;;
    all)
      add_auto_manual_to_each_xenbr_in_interfaces && add_auto_manual_to_each_xenbr_in_interfaces_d
      add_bridge_ports_to_each_xenbr_in_interfaces && add_bridge_ports_to_each_xenbr_in_interfaces_d
      ;;
    *)
      echo "Usage: $0 <aamf|aamd>"
      echo "  aamf - Add auto/manual to file <FILEPATH>"
      echo "  aamd - Add auto/manual to each file in dir <DIRPATH> in file by mask <MASK>"
      echo "  aamif - Add auto/manual to /etc/network/intefaces"
      echo "  aamid - Add auto/manual to /etc/network/intefaces.d/*.cfg"
      echo "  aamifd - aamif and aamid"
      echo ""
      echo "  abpf - Add bridge_ports under each xenbrX in file <FILEPATH>"
      echo "  abpd - Add bridge_ports under each xenbrX in dir <DIRPATH> in file by mask <MASK>"
      echo "  abpif - Add bridge_ports under each xenbrX in /etc/network/interfaces"
      echo "  abpid - Add bridge_ports under each xenbrX in /etc/network/interfaces.d/*.cfg"
      echo "  abpifd - abpif and abpid"
      echo ""
      echo "  all - aamidf and apbidf"
      ;;
  esac
fi
