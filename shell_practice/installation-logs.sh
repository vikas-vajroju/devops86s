#!/bin/bash
#installtion script


USERID=$(id -u)
logs_folder="/var/log/shell-script"
script_name=$( echo $0 | cut -d "." -f1 )
log_file="$log_folder/$script_name.log"
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

dnf list installed mysql &>>$log_file

if [ $? -ne 0 ]; then
    dnf install mysql -y &>>$log_file
    validate $? MYSQL
else
    echo "MYSQL skip Installation as package is already installed"
fi

dnf list installed nginx &>>$log_file

if [ $? -ne 0 ]; then
    dnf install nginx -y &>>$log_file
    validate $? NGINX
else
    echo "NGINX skip Installation as package is already installed"
fi


dnf list installed python3 &>>$log_file

if [ $? -ne 0 ]; then
    dnf install python3 -y &>>$log_file
    validate $? PYTHON3
else
    echo "Python3 skip Installation as package is already installed"
fi