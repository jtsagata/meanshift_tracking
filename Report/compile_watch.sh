#!/bin/bash

while true; do inotifywait -e modify *.tex; rubber -d MeanShiftReport.tex; done
