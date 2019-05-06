#!/usr/bin/env bash
#
# Copyright (c) Microsoft Corporation. All rights reserved.
set -e

COMMIT=$1
QUALITY=$2
VSCODE_REMOTE_BIN=$3

DOWNLOAD_URL="https://update.code.visualstudio.com/commit:$COMMIT/server-linux-x64/$QUALITY"

download()
{
	local url=$1
	local name=$2
	echo -n "    "
	wget -O "$name" -o /dev/stdout --progress=dot "$url" 2>&1 | grep --line-buffered "%" | \
		sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2); fflush()}'
	if [ ! -s "$name" ]; then
		echo Failed
		set +e
		wget -O "$name" "$url"
		local rc=$?;
		echo ERROR: Failed to download $url to $name 1>&2
		if [[ $rc == 5 ]]; then 
			echo Please install missing certificates. 1>&2
			echo Debian/Ubuntu:  sudo apt-get install ca-certificates 1>&2
		fi
		exit 13
	fi
	echo -ne "\b\b\b\b"
	echo "100%"
}

# Check if this version is already installed
if [ ! -d "$VSCODE_REMOTE_BIN/$COMMIT" ]; then
	# This version does not exist
	if [ -d "$VSCODE_REMOTE_BIN" ]; then
		echo "Updating VS Code Server to version $COMMIT"

		# Remove the previous installations
		pushd "$VSCODE_REMOTE_BIN" > /dev/null
		echo "Removing previous installation...";
		rm -rf ????????????????????????????????????????
		rm -rf ????????????????????????????????????????-??????????
		rm -rf ????????????????????????????????????????-??????????.tar.gz
		popd > /dev/null

	else
		echo "Installing VS Code Server $COMMIT"
	fi

	mkdir -p "$VSCODE_REMOTE_BIN"

	# Download the .tar.gz file
	TMP_NAME="$COMMIT-$(date +%s)"
	echo -n "Downloading: ";
	download "$DOWNLOAD_URL" "$VSCODE_REMOTE_BIN/$TMP_NAME.tar.gz"

	# Unpack the .tar.gz file to a temporary folder name
	echo -n "Unpacking: ";
	mkdir "$VSCODE_REMOTE_BIN/$TMP_NAME"

	FILE_COUNT=`tar -tf "$VSCODE_REMOTE_BIN/$TMP_NAME.tar.gz" | wc -l`
	P=0;
	tar -xf "$VSCODE_REMOTE_BIN/$TMP_NAME.tar.gz" -C "$VSCODE_REMOTE_BIN/$TMP_NAME" --strip-components 1 --verbose | { I=1; echo -n "    "; while read; do I=$((I+1)); PREV_P=$P; P=$((100 * I / FILE_COUNT)); if [ "$PREV_P" -ne "$P" ]; then PRETTY_P="$P%"; printf "\b\b\b\b%4s" $PRETTY_P; fi; done; echo ""; }

	# Remove the .tar.gz file
	rm "$VSCODE_REMOTE_BIN/$TMP_NAME.tar.gz"

	# Rename temporary folder to final folder name, retries needed due to WSL
	for i in 1 2 3 4 5; do
		mv "$VSCODE_REMOTE_BIN/$TMP_NAME" "$VSCODE_REMOTE_BIN/$COMMIT" && break || sleep 2;
	done

	if [ ! -s "$VSCODE_REMOTE_BIN/$COMMIT" ]; then
		echo ERROR: Failed create $VSCODE_REMOTE_BIN/$COMMIT. Make sure all VSCode WSL windows are closed and try again. 1>&2
		exit 13
	fi
fi