function main {

	local _OPTIONS=(
		"sync custom theme"
		"sync images"
		"swap direction"
	)

	local _DIRECTION="local-remote"
	local _SRC
	local _DST
	local _CMD

	while true; do
		echo "---"
		echo -e "${MAGENTA}Select:${CLEAR}"
		select opt in "${_OPTIONS[@]}"; do
			case ${opt} in

				"sync custom theme")
					echo
					# direction
					case ${_DIRECTION} in
						"local-remote")
							_SRC="${SRC_THEME}"
							_DST="${DST_THEME}"
							;;
						"remote-local")
							_SRC="${DST_THEME}"
							_DST="${SRC_THEME}"
							;;
					esac
					_CMD="rsync --recursive --perms --times --chown=999:999 --numeric-ids --human-readable --progress --delete --exclude node_modules ${_SRC} ${_DST}"
					# feedback
					echo -e "SRC: ${CYAN}${_SRC}${CLEAR}"
					echo -e "DST: ${CYAN}${_DST}${CLEAR}"
					echo -e "CMD: ${CYAN}${_CMD}${CLEAR}"
					# enter
					echo "Hit enter to proceed!"
					read -n 1 -p ">> "
					echo
					if [[ -z ${REPLY} ]]; then
						${_CMD}
					fi
					;;

				"sync images")
					echo
					# direction
					case ${_DIRECTION} in
						"local-remote")
							_SRC="${SRC_IMGS}"
							_DST="${DST_IMGS}"
							;;
						"remote-local")
							_DST="${SRC_IMGS}"
							_SRC="${DST_IMGS}"
							;;
					esac
					# feedback
					_CMD="rsync --recursive --perms --times --chown=999:999 --numeric-ids --human-readable --progress --delete ${_SRC} ${_DST}"
					echo -e "SRC: ${CYAN}${_SRC}${CLEAR}"
					echo -e "DST: ${CYAN}${_DST}${CLEAR}"
					echo -e "CMD: ${CYAN}${_CMD}${CLEAR}"
					# enter
					echo "Hit enter to proceed!"
					read -n 1 -p ">> "
					echo
					if [[ -z ${REPLY} ]]; then
						${_CMD}
					fi
					;;
				
				"swap direction")
					# swap direction
					case ${_DIRECTION} in
						"local-remote")
							_DIRECTION="remote-local";;
						"remote-local")
							_DIRECTION="local-remote";;
					esac
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