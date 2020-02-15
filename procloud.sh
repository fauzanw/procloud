checkDependencies() {
   echo -e '\033[94m[\033[93m!\033[94m]\033[97m Checking Dependencies....'
   sleep 1
   checkOS=$(uname -o)
   dpkg-query -W -f='${Status} ${Version}\n' dnsutils > /dev/null 2>&1
   if [[ $? -eq 0 ]]; then
        printf '\033[94m[\033[92m+\033[94m]\033[93m dnsutils \033[97m...........\033[94m(\033[92m✔\033[94m)\033[97m\n'
   else
        printf '\033[94m[\033[91m-\033[94m]\033[93m dnsutils \033[97m...........\033[94m(\033[91m✘\033[94m)\033[97m\n'
        sleep 1
        if [[ $checkOS == 'GNU/Linux' ]]; then
                sudo apt install dnsutils > /dev/null 2>&1
        else
                apt install dnsutils > /dev/null 2>&1
        fi
   fi
   sleep 1

   dpkg-query -W -f='${Status} ${Version}\n' curl > /dev/null 2>&1
   if [[ $? -eq 0 ]]; then
        printf '\033[94m[\033[92m+\033[94m]\033[93m cURL \033[97m...........\033[94m(\033[92m✔\033[94m)\033[97m'
   else
        printf '\033[94m[\033[91m-\033[94m]\033[93m cURL \033[97m...........\033[94m(\033[91m✘\033[94m)\033[97m'
        if [[ $checkOS == 'GNU/Linux' ]]; then
                sudo apt install curl > /dev/null 2>&1
        else
                apt install curl > /dev/null 2>&1
        fi
   fi
   clear
}
banner() {
   printf "
\t \033[97;1m                ..            \033[0m   \033[91m _____\033[97m        \033[91m _____\033[97m _           _ 
\t \033[97;1m            -/+ooooo+:.       \033[0m   \033[91m|  _  \033[91m|\033[97m___ ___\033[91m|     \033[97m| |___ _ _ _| |
\t \033[97;1m          -oooooooooooo+.     \033[0m   \033[91m|   __\033[97m|  _| . \033[91m|  |--\033[97m| | . | | | . |
\t \033[97;1m     -/oo+ooooooooooooooo-    \033[0m   \033[91m|__|  \033[97m|_| |___\033[91m|_____\033[97m|_|___|___|___|\033[97;1m
\t \033[97;1m   ':ooooooooooooooooooooo'   \033[0m   \033[93;2mProCloud Version 1.0\033[0m\033[97;1m
\t \033[97;1m :+ooooooooooooooooooooooo/-' \033[0m   \033[97;1mCoded By \033[92;1mFauzanw\033[0m\033[97;1m from { IndoSec }
\t \033[97;1m/oooooooooooooooooooooooooooo-\033[0m
\t \033[97;1moooooooooooooooooooooooooooooo\033[0m
\t \033[97;1m-oooooooooooooooooooooooooooo/\033[0m
\t \033[97;1m ./+ooooooooooooooooooooooo+- \033[0m
\t \033[97;1m     ''''''''''''''''''''''   \033[0m 
   \n"
}

main() {
  printf "\033[94m[\033[93m!\033[94m]\033[97m Mengecek Host...\n";
  if [[ $(host $host | grep "not found") ]]; then
    printf "\033[94m[\033[91m-\033[94m] \033[97;1m$host \033[0m\033[97mbukan host yang valid \033[94m(\033[91m✘\033[94m)\033[0m\n"
    exit
  else
    printf "\033[94m[\033[92m+\033[94m]\033[97;1m $host \033[0m\033[97madalah host yang valid \033[94m(\033[92m✔\033[94m)\033[97m\n"
    sleep 1
    printf "\033[94m[\033[93m!\033[94m]\033[97m Mengecek server...\n";
    if [[ $(curl -i --silent $(host $host | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}') | grep "cloudflare") ]]; then
      printf "\033[94m[\033[92m+\033[94m] \033[97mIP HOST : \033[97;1m$(host $host | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}' | head -n1)\033[0m\n"
      printf "\033[94m[\033[92m+\033[94m]\033[97m Server  : \033[92mCloudFlare\n"
      sleep 1
      if [[ $(host server.$host | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}') ]]; then
        printf "\033[94m[\033[92m+\033[94m]\033[97m Real IP : \033[97;1m$(host server.$host | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}' | head -n1)\033[0m\n"
      else
        printf "\033[94m[\033[91m-\033[94m]\033[97m Can't Get Real IP Cloudflare \033[94m(\033[91m✘\033[94m)\033[0m"
      fi
    else
      printf "\033[94m[\033[92m+\033[94m] \033[97mIP HOST : \033[97;1m$(host $host | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}' | head -n1)\033[0m\n"
      printf "\033[94m[\033[91m-\033[94m]\033[97m Server  : \033[92m$(curl -i --silent $(host google.com | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}') | grep -Po '(?<=Server: )[^,]*')\n"
      printf "\033[94m[\033[91m-\033[94m]\033[97;1m $host\033[0m\033[97m tidak menggunakan server CloudFlare \033[94m(\033[91m✘\033[94m)\033[0m\n"
    fi
  fi

}

clear
checkDependencies
banner
printf "\033[94m[\033[93m?\033[94m] \033[97mHost : ";
read host;
main host
