#!/bin/bash

# Generate `coverage/lcov.info` file
fvm flutter test --coverage
# Generate HTML report
genhtml coverage/lcov.info -o coverage/html
# Open the report
open coverage/html/index.html