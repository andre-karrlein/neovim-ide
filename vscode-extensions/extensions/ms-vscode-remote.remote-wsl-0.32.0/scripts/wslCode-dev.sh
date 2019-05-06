#!/usr/bin/env bash
#
# Copyright (c) Microsoft Corporation. All rights reserved.
VSCODE_PATH=$1

PROBE=$(mktemp /tmp/vscode-distro-probe.XXXXXX)
PROBE_RESULT=$(wsl.exe bash -c "[ -f $PROBE ] && echo 'Found'" | tr -d '\0')
if [ "$PROBE_RESULT" != "Found" ]; then
    echo "Visual Studio Code for WSL currently only supports the default distro. Use 'wslconfig.exe' to configure the default distro.";
    exit $?
fi

VSCODE_REMOTE_DEPENDENCIES="$HOME/.vscode-remote/bin/dev-remote"
"$(dirname "$0")/wslDownload-dev.sh" $VSCODE_PATH

export VSCODE_INJECT_NODE_MODULE_LOOKUP_PATH="$VSCODE_REMOTE_DEPENDENCIES/node_modules"
export VSCODE_CLIENT_COMMAND=$(wslpath -w "$VSCODE_PATH/scripts/code.bat")
export VSCODE_CLIENT_COMMAND_CWD="$VSCODE_PATH/scripts"
export VSCODE_CLI_AUTHORITY="wsl+default"

CLI_SCRIPT="$VSCODE_PATH/out/remoteCli.js"

# node "$VSCODE_PATH/out/remoteCli.js" PROD_NAME VERSION COMMIT EXEC_NAME
node "$CLI_SCRIPT" "Code OSS Dev" "" "" "code.sh" "${@:2}"