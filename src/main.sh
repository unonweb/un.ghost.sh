#!/bin/bash

set -o errexit
set -o pipefail
#set -o nounset

# script location
export SCRIPT_PATH="$(readlink -f "${BASH_SOURCE}")"
export SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE}")")
export SCRIPT_NAME=$(basename -- "$(readlink -f "${BASH_SOURCE}")")
export SCRIPT_PARENT=$(dirname "${SCRIPT_DIR}")

export CLEAR="\e[0m"
export BOLD="\e[1m"
export UNDERLINE="\e[4m"
export RED="\e[31m"
export GREEN="\e[32m"
export YELLOW="\e[33m"
export BLUE="\e[34m"
export MAGENTA="\e[35m"
export CYAN="\e[36m"

# IMPORTS
source "${SCRIPT_DIR}/lib/readFileToMap.sh"

function main {

	# globals
	PATH_CONFIG="${SCRIPT_PARENT}/config.cfg"
	OPTIONS=(
		"sync"
		"backup/restore"
		"create/remove site"
		"show config"
	)

	# CONFIG
	declare -A CONFIG
	readFileToMap CONFIG ${PATH_CONFIG}
	export SRC_GHOST=${CONFIG[SRC_GHOST]}
	export SRC_CONTENT=${CONFIG[SRC_CONTENT]}
	export SRC_THEME=${CONFIG[SRC_THEME]}
	export SRC_IMGS=${CONFIG[SRC_IMGS]}
	export DST_CONTENT=${CONFIG[DST_CONTENT]}
	export DST_THEME=${CONFIG[DST_THEME]}
	export DST_IMGS=${CONFIG[DST_IMGS]}

	while true; do
		echo "---"
		echo -e "${MAGENTA}Select:${CLEAR}"
		select opt in "${OPTIONS[@]}"; do
			echo "${opt}"
			case ${opt} in

				"sync")
					${SCRIPT_DIR}/run/un.ghost.sync.sh
					;;

				"backup/restore")
					${SCRIPT_DIR}/run/un.ghost.backup-restore.sh
					;;
				
				"create/remove site")
					${SCRIPT_DIR}/un.ghost.create-remove-site.sh
					;;
				
				"show config")
					echo
					for key in ${!CONFIG[@]}; do 
						echo "${key}=${CONFIG[${key}]}"
					done
					;;
			esac
			break
		done
	done
}

main