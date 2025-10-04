#!/bin/bash
#installtion script


USERID=$(id -u)

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

dnf list installed mysql

if [ $? -ne 0 ]; then
    dnf install mysql -y
    validate $? MYSQL
else
    echo "MYSQL skip Installation as package is already installed"
fi

dnf list installed nginx

if [ $? -ne 0 ]; then
    dnf install nginx -y
    validate $? NGINX
else
    echo "NGINX skip Installation as package is already installed"
fi


dnf list installed python3

if [ $? -ne 0 ]; then
    dnf install python3 -y
    validate $? PYTHON3
else
    echo "Python3 skip Installation as package is already installed"
fi