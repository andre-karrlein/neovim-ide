#!/usr/bin/env bash
#
# Copyright (c) Microsoft Corporation. All rights reserved.
COMMIT=$1
QUALITY=$2
DATAFOLDER=$3

shift 3

if  [[ $4 =~ ^\-\-inspect ]]; then
	INSPECT=$4
	set -x
	shift
fi

VSCODE_REMOTE_BIN="$HOME/$DATAFOLDER/bin"

export PATH="$VSCODE_REMOTE_BIN/$COMMIT/bin:$PATH"

$(dirname "$0")/wslDownload.sh $COMMIT $QUALITY "$VSCODE_REMOTE_BIN"
RC=$?;
if [[ $RC != 0 ]]; then 
    exit $RC
fi

"$VSCODE_REMOTE_BIN/$COMMIT/server.sh" ${INSPECT:-} --port=0 "$@"
