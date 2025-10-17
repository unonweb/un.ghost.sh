function main {

	local OPTIONS=(
		"sync custom theme"
		"sync images"
	)

	while true; do
		echo "---"
		echo -e "${MAGENTA}Select:${CLEAR}"
		select opt in "${OPTIONS[@]}"; do
			echo "${opt}"
			case ${opt} in

				"sync custom theme")
					echo
					CMD="rsync --recursive --perms --times --chown=999:999 --numeric-ids --human-readable --progress --delete --exclude node_modules ${SRC_THEME} ${DST_THEME}"
					echo -e "SRC: ${CYAN}${SRC_THEME}${CLEAR}"
					echo -e "DST: ${CYAN}${DST_THEME}${CLEAR}"
					echo -e "CMD: ${CYAN}${CMD}${CLEAR}"
					${CMD}
					;;

				"sync images")
					echo
					echo -e "Syncing images from ${CYAN}${SRC_IMGS}${CLEAR} to ${CYAN}${DST_IMGS}${CLEAR}"
					rsync --recursive --perms --times --chown=999:999 --numeric-ids --human-readable --progress --delete ${SRC_IMGS} ${DST_IMGS}
					;;
				
				"-> return ")
					return 0
					;;
			esac
			break
		done
	done
}

main