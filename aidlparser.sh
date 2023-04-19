#!/bin/bash

PATH=$PATH:./

readthefile () {
    cat *.aidl
}


ParseServiceAIDL () {
    readthefile "$TAG" $(echo "$SERVICE_PACKAGE" | sed 's/\./\//g')$(echo ".aidl") | \
    gcc -P -E - | grep -v '@UnsupportedAppUsage' | tr '{};\n\r' '\n\n\n  ' | grep -v ^$ | sed -e '1,/interface\s/ d' | cat -n
}

AbortIfExecutableMissing () {
    BIN=($@)
    MISSINGBIN=$(for B in ${BIN[@]}; do [ "$(which $B 2>/dev/null)-" == "-" ] && echo $B; done)
    [ "${MISSINGBIN}-" == "-" ] && return 0
    echo -e "Can't find the following executables: "$MISSINGBIN
    exit 1
}

ParseServiceAIDL

exit 0
