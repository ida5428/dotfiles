#!/usr/bin/env bash

man -k . | awk -F '(' '{print $1}' | sort -u | fzf --bind='esc:cancel,enter:execute(bash -c "man {}")'

