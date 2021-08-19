#!/bin/bash

# constants
tex='\033[';
norm='0;3';
bold='1;3';
ital='3;3';
undl='4;3';
lt='9;3';

Black='0m'
R='1m'
G='2m'
O='3m'
B='4m'
P='5m'
C='6m'
Gray='7m'
no_col='\033[0m'


# function definitions
dot_anim(){
    for (( i = 0; i < $1; i++ )); do
        echo -n '.'
        sleep 1
    done
    echo
}

check_connection(){
    response=$(ping -c 2 8.8.8.8 2> neterror)
    if [[ "$(cat neterror)" == "ping: connect: Network is unreachable" ]]; then
        echo "Network unreachable, Check the connection and try again.."
        exit
    else
        echo -n "Network available"
        dot_anim 2
    fi
}

show_weather(){
    echo -e -n "${tex}${bold}${Gray}"
    date=$(date '+%d')
    if [[ ! -e "wlog" ]]; then
        echo -e "Fetching today's weather statistics\n"
        wget wttr.in -o wlog -O weather.html
    elif [[ $date != $(head wlog -n 1 | cut -c 11-12) ]]; then
        echo -e "Fetching weather statistics for today..\n"
        wget wttr.in -o wlog -O weather.html
    else
        echo -e "Today's weather statistics available.."
        sleep 1
    fi

    echo -n -e "\nToday's "
    head weather.html -n 7
    echo

    read -p "View detailed Weather Report? (Y/N): " ans

    case $ans in
        y | Y)
            head weather.html -n 17 | tail -n 10
            ;;
    esac
    sleep 2
    echo
}

clean_toi_data(){
    data=$(cat $1 | sed -e "s@<item>@&\n@g" | sed -e "s@</title>@&\n@g" | grep "<title>" | grep -v "http" | cut -c 8- | rev | cut -c 9- | rev)
    echo "$data" > text
    n=$(grep -c '\n' text)
    echo -e -n "${tex}${norm}${O}"
    for (( i=1; i <= n ; i++ )) do
        echo -n -e "$i. "
        head text -n $i | tail -n 1
        sleep 1
    done
}

fetch_url(){
    toi_url="https://timesofindia.indiatimes.com/"

    if [[ "$1" == "headlines" ]]; then
        url="${toi_url}rssfeedstopstories.cms"
        echo "$url"
        exit
    fi

    url="${toi_url}rssfeeds/"
    case "$1" in
        "bangalore" | "bengaluru")
            url="${url}-2128833038.cms"
            ;;
        "health")
            url="${url}3908999.cms"
            ;;
        "sports")
            url="${url}4719148.cms"
            ;;
        "science")
            url="${url}-2128672765.cms"
            ;;
        "business")
            url="${url}1898055.cms"
            ;;
        "education")
            url="${url}913168846.cms"
            ;;
        "world")
            url="${url}296589292.cms"
            ;;
        "tech")
            url="${url}66949542.cms"
            ;;
        "entertainment")
            url="${url}1081479906.cms"
            ;;
        *)
            echo "INVALID"
            return
            ;;
    esac

    echo "${url}"
}

show_news(){
    url=$(fetch_url $1)
    if [[ "$url" == "INVALID" ]]; then
        echo "Invalid Entry.. Try again"
        return
    fi

    wget $url -o nlog -O news
    sleep 1
    echo -e -n "${tex}${bold}${O}"

    if [[ "$1" == "headlines" ]]; then
        echo -e "\n\n\t  HEADLINES"
        sleep 1
        clean_toi_data news | head -n 10
        echo -e "\n"
        return
    fi

    echo -e "\n\t  ${1^^} NEWS"
    sleep 1
    clean_toi_data news | head -n 5
    echo
    sleep 1
}

exit_handler(){
    echo -e "${tex}${bold}${P}\n\tHave a Good day!"
    sleep 1
    exit
}

categorized_news(){
    echo -e "${tex}${norm}${R}\n"
    echo -e "- bangalore\n- education\n- business\n- health\n- sports"
    echo -e "- science\n- tech\n- entertainment\n- world"
    echo -e "- \"return\" to main menu"
    while :
    do
        echo -e -n "${tex}${norm}${R}"
        read -p "enter>> " ans

        if [[ "$ans" == "return" || "$ans" == "0" ]]; then
            return
        fi

        show_news $ans
    done
}


# execution starts from here
if [[ ! -e news_files ]]; then
    mkdir news_files
fi
cd news_files

echo -e -n "${tex}${bold}${P}\n\tGood "

hour=$(date '+%H')
if [[ $hour < 12 ]]; then
    echo -e -n "Morning"
elif [[ $hour < 16 ]]; then
    echo -e -n "After Noon"
else
    echo -e -n "Evening"
fi

username=$(whoami)
echo -e " ${username^}!"
sleep 2
echo "Today is $(date "+%A, %d %B %Y")"
sleep 1
echo -e "TIME is $(date '+%R %Z')"
sleep 1

check_connection    #calling check_connection function

read -p "View Today's News? (Y/N): " ans

case $ans in
    n | N)
        exit_handler
        ;;
esac

show_news headlines

while :
do
    echo -e "\n\t${tex}${bold}${R}MAIN MENU${tex}${norm}${R}"
    echo -e "1.Categorized News\n2.Weather Report\n0.Exit"
    read -p "choice>> " ans
    case $ans in
        0)
            exit_handler
            ;;
        1)
            categorized_news
            ;;
        2)
            show_weather
            ;;
        *)
            echo "Invalid choice.. try again"
    esac
done


# script ends here

# 0 - Normal Style
# 1 - Bold
# 2 - Dim
# 3 - Italic
# 4 - Underlined
# 5 - Blinking
# 7 - Reverse
# 8 - Invisible
