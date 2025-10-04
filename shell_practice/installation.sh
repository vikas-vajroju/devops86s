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

mysql=$(dnf list installed mysql)
if [ $mysql -ne 0 ]; then
    echo "Installing $(dnf install mysql -y)"
    exit 1
else
    echo "MYSQL skip Installation"
fi

validate $? MYSQL

dnf install nginx -y 

validate $? "NGINX"


dnf install mongodb-mongosh -y 

validate $? MongoDB