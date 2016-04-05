#!/bin/bash

if [ "$(basename $PWD)" != "tests" ]; then
	echo "Must run tests from tests/ directory"
	exit 1
fi
. util.sh

init_all

test_it_long GET html/index.html "" ""
test_it_code GET html/index.html "" "200"
test_it_code GET html/ "" "200"
test_it_code_moved GET html "" "301"
#echo "lwp-request -USsed -C ${PASS} http://localhost:$AGENT_PORT/html)"
FOO=$(curl -u ${PASS} -IL -vs http://localhost:$AGENT_PORT/html --stderr -)
if [ "x$?" = "x0" ]; then pass; else fail "$*: $FOO"; fi
inc
if echo -e "$FOO" | grep -q "200 OK"; then pass; else fail "Redirect failed to yield 200 OK"; fi
inc
if echo -e "$FOO" | grep -q "Location: http://localhost:$AGENT_PORT/html/"; then pass; else fail "Location: header incorrect in redirect:" $(echo -e "$FOO" | grep Location); fi
inc
exit $ret
