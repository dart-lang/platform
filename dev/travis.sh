#!/bin/bash
# Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Make sure dartfmt is run on everything
echo "Checking dart format..."
needs_dart_format="$(dart format --set-exit-if-changed --output=none lib test dev 2>&1)"
if [[ $? != 0 ]]; then
  echo "FAILED"
  echo "$needs_dart_format"
  exit 1
fi
echo "PASSED"

# Make sure we pass the analyzer
echo "Checking dartanalyzer..."
fails_analyzer="$(find lib test dev -name "*.dart" --print0 | xargs -0 dartanalyzer --options analysis_options.yaml 2>&1)"
if [[ "$fails_analyzer" == *"[error]"* ]]; then
  echo "FAILED"
  echo "$fails_analyzer"
  exit 1
fi
echo "PASSED"

# Make sure we could publish if we wanted to.
echo "Checking publishing..."
fails_publish="$(pub publish --dry-run 2>&1)"
if [[ $? != 0 ]]; then
  echo "FAILED"
  echo "$fails_publish"
  exit 1
fi
echo "PASSED"

# Fast fail the script on failures.
set -e

# Run the tests.
pub run test
