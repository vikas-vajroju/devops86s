#!/bin/bash

USERID=$(id -u)
logs_folder="/var/log/shell-script"
script_name=$( echo $0 | cut -d "." -f1 )
log_file="$logs_folder/$script_name.log"
mkdir -p $logs_folder

if [ $USERID -ne 0 ]; then
    echo "ERROR : please run the script with root user access "
    exit 1
fi

validate(){
    if [ $1 -ne 0 ]; then
        echo "error :: installation $2 failed"
        exit 1
    else
        echo "$2 Installation is success"
    fi
}

echo "Scripting starting $(date)"

for package in $@
# do
#     dnf list installed "$package" &>>"$log_file"
#     if [ $? is -ne 0 ]; then
#         dnf install "$package" -y &>>"$log_file"
#         validate $? "$package"
#     else
#         echo "$package is already installed ....SKIPPING..."
#     fi
# done

do
    
    if ! dnf list installed "$package" &>>"$log_file"; then
        dnf install "$package" -y &>>"$log_file"
        validate $? "$package"
    else
        echo "$package is already installed ....SKIPPING..."
    fi
done