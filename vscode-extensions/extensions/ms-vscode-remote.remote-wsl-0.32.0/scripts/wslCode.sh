#!/usr/bin/env bash
#
# Copyright (c) Microsoft Corporation. All rights reserved.
COMMIT=$1
QUALITY=$2
WIN_CODE_CMD=$3
APP_NAME=$4

VSCODE_REMOTE_BIN="$HOME/.vscode-remote/bin"

PROBE=$(mktemp /tmp/vscode-distro-probe.XXXXXX)
PROBE_RESULT=$(wsl.exe bash -c "[ -f $PROBE ] && echo 'Found'" | tr -d '\0')
if [ "$PROBE_RESULT" != "Found" ]; then
    echo "Visual Studio Code for WSL currently only supports the default distro. Use 'wslconfig.exe' to configure the default distro.";
    exit $?
fi

"$(dirname "$0")/wslDownload.sh" "$COMMIT" "$QUALITY" "$VSCODE_REMOTE_BIN"
RC=$?;
if [[ $RC != 0 ]]; then 
    exit $RC
fi

VSCODE_CLIENT_COMMAND=$WIN_CODE_CMD \
VSCODE_CLIENT_COMMAND_CWD="$(dirname "$0")" \
VSCODE_CLI_AUTHORITY="wsl+default" \
"$VSCODE_REMOTE_BIN/$COMMIT/bin/$APP_NAME" "${@:5}"