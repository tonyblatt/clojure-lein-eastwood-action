#!/bin/bash

cd "${GITHUB_WORKSPACE}" || exit 1

git config --global --add safe.directory "$GITHUB_WORKSPACE" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

lein eastwood "${INPUT_EASTWOOD_FLAGS}" \
  | sed -e "s/ /-=-/g" \
  | python3 parse_lines.py \
  | reviewdog \
      -efm="%f:%l:%c: %m" \
      -name="clj-kondo" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      "${INPUT_REVIEWDOG_FLAGS}"

exit_code=$?

exit $exit_code