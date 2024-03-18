
# - declare color constants
declare -r RED='\033[1;31m'
declare -r LGREEN='\033[1;92m'
declare -r LCYAN='\033[0;96m'
declare -r BOLD='\033[1m'
declare -r NC='\033[0m' # No Color

function main {
    if [ $UID == 0 ]
    then
        printf "${RED}[!] Error this script can only be used by the normal user ${NC}\n"
    
    else
        message_box
        install_cpan
        execute
    fi

exit
}

function install_cpan() {
    printf "${LCYAN}${BOLD}[!] Installing SHAUR for Arch Linux\n"
    echo -e "-----------------------------------${NC}";
    printf "$LCYAN[+] Installing necessary Perl modules...${NC}\n"
    cpan install JSON Env
    if [ $? -ne 0 ]; then
        printf "${RED}[!] Error installing Perl modules.${NC}\n"
        exit 1
    fi
    echo "" 
}

function message_box() {
    dialog --backtitle "Setup install SHAUR" --title "Simple Helper AUR install" \
    --msgbox "this tool is covered by the gpl3 license\n
    	\ngithub: antogit-sys\n\n\n      
    	proceed with the installation?..." \
    10 50
    clear
}

execute() {
    pkg_installed_dir="$HOME/.shaur/pkg-installed"
    
    printf "${LCYAN}[+] create shaur command${NC}\n";
    sudo printf ""
    printf "Copying shaur.pl to... "
    sleep 1
    sudo cp shaur.pl /usr/local/bin/shaur
    if [ $? -ne 0 ]; then
        printf "${RED}[!] Error moving shaur.pl.${NC}\n"
        exit 1
    fi
    printf "$LGREEN/usr/local/bin/shaur${NC}\n"

    printf "Copying shaurFunction recursively to... "
    sleep 2
    sudo cp -r shaurFunctions /usr/local/bin/shaurFunctions
    if [ $? -ne 0 ]; then
        printf "${RED}[!] Error copying shaurFunctions.${NC}\n"
        exit 1
    fi
    printf "$LGREEN/usr/local/bin/shaurFunctions${NC}\n"

    printf "shaur is... "
    sleep 1
    sudo chmod a+x /usr/local/bin/shaur
    printf "${LGREEN}excutable$NC\n\n"
    
    printf "$LCYAN[+] create config file$NC\n"
    if [ ! -d "$pkg_installed_dir" ]; then
        # If it doesn't exist, create it
        mkdir -p "$pkg_installed_dir"
        echo -e "Directory '$pkg_installed_dir' created successfully.\n"
    else
        echo -e "Directory '$pkg_installed_dir' already exists.\n"
    fi
    printf "${LCYAN}${BOLD}Installation completed.${NC}\n\n"
	
}

main
