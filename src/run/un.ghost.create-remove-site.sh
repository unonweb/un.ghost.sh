#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

CLEAR="\e[0m"
# Text settings.
BOLD="\e[1m"
UNDERLINE="\e[4m"
# Text color.
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"

function createGhostSite() {
    local SITE

    echo -e "${CYAN}Enter site name: ${CLEAR}"
    read -p ">> " SITE

    #echo "Mdkir ..."
    sudo mkdir "/var/www/${SITE}"

    #echo "Chown ..."
    sudo chown cms:cms "/var/www/${SITE}"

    # Set the correct permissions
    sudo chmod 775 "/var/www/${SITE}"
    # Then navigate into it
    cd "/var/www/${SITE}"

    #echo "Installing ghost ..."
    npx -g ghost install
    echo "---"
    echo
    echo -e "${UNDERLINE}TO DO${CLEAR}:"
    echo "nano config.production.json"
    echo '"host": "127.0.0.1" --> "host": "0.0.0.0"'
}

function main() {
    local OPTIONS=(
        "Create new site"
        "Remove site dir"
        "Disable service"
        "Remove database"
    )
	
    while true; do
        echo -e "${CYAN}Select:${CLEAR}"
        select OPT in "${OPTIONS[@]}"; do
            if [[ -z ${OPT} ]]; then
                echo "Error: Invalid choice '$REPLY'"
            fi

            case ${OPT} in
		    "Remove site dir")
		        echo
		        echo "Sites available:"
		        ls -l /var/www/
		        echo "---"
		        echo -e "${CYAN}Enter site name: ${CLEAR}"
                read -p ">> " SITE
                sudo rm -r "/var/www/${SITE}"
                ;;
            "Disable service")
                echo
                echo "Services available:"
                systemctl list-unit-files --type service "ghost_*"
                echo "---"
                echo -e "${CYAN}Enter service name: ${CLEAR}"
                read -p ">> " SERVICE
                sudo systemctl disable --now "${SERVICE}"
                ;;
            "Remove database")
                echo
                mysql -u root -p -e "SHOW DATABASES;"
                echo -e "${CYAN}Enter db name: ${CLEAR}"
                read -p ">> " DB
                mysql -u root -p -e "DROP DATABASE ${DB};"
                ;;
            "Create new site")
                echo
                createGhostSite
                ;;
            esac

            break

        done
    done
}

main
