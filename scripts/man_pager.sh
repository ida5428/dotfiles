#!/usr/bin/env bash

man -k . | sort | uniq | awk -F '(' '{print $1}' | fzf --bind='esc:cancel,enter:execute(bash -c "man {}")'

