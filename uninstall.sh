
# - declare color constants
declare -r RED='\033[1;31m'
declare -r LGREEN='\033[1;92m'
declare -r LCYAN='\033[0;96m'
declare -r YELLOW='\033[93m'
declare -r BOLD='\033[1m'
declare -r NC='\033[0m' # No Color


function main {
    if [ $UID == 0 ]
    then
        printf "${RED}[!] Error this script can only be used by the normal user ${NC}\n"

    else
        banner
        sudo printf ""
        execute
    fi

exit
}

function banner {
    clear
    printf "${YELLOW}${BOLD}[*] Uninstalling SHAUR for Arch Linux :(\n"
    echo -e "----------------------------------------${NC}";
}

execute() {
    config_dir="$HOME/.shaur/"
    
    printf "${YELLOW}[-] Deleting shaur command${NC}\n";
    
    printf "Deleting shaur from... "
    sleep 1
    sudo rm /usr/local/bin/shaur
    if [ $? -ne 0 ]; then
        printf "${RED}[!] Error deleting shaur command.${NC}\n"
        exit 1
    fi
    printf "$RED/usr/local/bin/shaur${NC}\n"

    printf "Deleting shaurFunction from... "
    sleep 2
    sudo rm -rf /usr/local/bin/shaurFunctions
    if [ $? -ne 0 ]; then
        printf "${RED}[!] Error deleting directory shaurFunctions.${NC}\n"
        exit 1
    fi
    printf "$RED/usr/local/bin/shaurFunctions/${NC}\n\n"
    
    printf "$YELLOW[-] Deleting config file$NC\n"
    if [ ! -d "$config_dir" ]; then
        echo -e "Directory '$config_dir' does not exist.\n"
    else
        sudo rm -rf $config_dir
        echo -e "Directory '$config_dir'... ${RED}deleted${NC}\n"
    fi
    printf "${YELLOW}${BOLD}[!] Uninstallation completed.${NC}\n\n"
	
}

main
