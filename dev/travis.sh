#!/bin/bash
# Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Make sure dartfmt is run on everything
echo "Checking dartfmt..."
needs_dartfmt="$(dartfmt -n lib test dev)"
if [[ -n "$needs_dartfmt" ]]; then
  echo "FAILED"
  echo "$needs_dartfmt"
  exit 1
fi
echo "PASSED"

# Make sure we pass the analyzer
echo "Checking dartanalyzer..."
fails_analyzer="$(find lib test dev -name "*.dart" | xargs dartanalyzer --options analysis_options.yaml)"
if [[ "$fails_analyzer" == *"[error]"* ]]; then
  echo "FAILED"
  echo "$fails_analyzer"
  exit 1
fi
echo "PASSED"

# Fast fail the script on failures.
set -e

# Run the tests.
pub run test
