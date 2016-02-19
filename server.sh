#!/bin/bash

ulimit -c unlimited
while true; do ./tfs --log-file="serverlog.txt" "error.txt"; done
