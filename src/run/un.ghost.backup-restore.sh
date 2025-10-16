function main {

	OPTIONS=(
		"backup content"
		"restore content"
		"-> return"
	)

	while true; do
		echo -e "${MAGENTA}Select:${CLEAR}"
		select opt in "${OPTIONS[@]}"; do
			echo "${opt}"
			case ${opt} in
			
				"backup content")
					cd ${SRC_GHOST}
					npx -g ghost backup
					;;

				"restore content")
					echo -e "${CYAN}Which backup.zip do you want to restore?${CLEAR}"
					ls ${SRC_GHOST}/*.zip
					read -p ">> "
					if [[ -f "${REPLY}" ]]; then
						sudo unzip "${REPLY}" -d /var/lib/machines/ghost-ub/var/www/radjajuschka.de/content
						sudo chown -R vu-ghost-ub-999:vg-ghost-ub-999 /var/lib/machines/ghost-ub/var/www/radjajuschka.de/content
						echo "Run the following cmd on the container:"
						echo "npx -g ghost import content/data/content-from[backup-name].json"
					else
						echo "Error: Backup does not exist: ${REPLY}"
					fi
					;;
				
				"-> return")
					return 0
					;;

			esac
			break
		done
	done
}

main