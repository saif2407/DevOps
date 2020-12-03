#!/bin/bash

checkArgs(){
    NARGS=$#
    if (( $NARGS != 2 ))
    then
        echo "ERROR: Provide domain name and directory location"
        exit
    fi
}

checkSudo(){

     apt update 
     STATUSSUDO=$?
     if [ $STATUSSUDO -ne 0 ]
     then
         echo "ERROR: plz login with sudo privilage"
         exit
     fi 
}

checkApache2Exist(){
    if [ ! -e "/etc/apache2" ]
    then
       echo "ERROR: apache2 not installed"
       installApache2

    else
       status=$(sudo systemctl status apache2)
       ecode=$?
       if [ $ecode == 0 ]
       then
       echo "Apache2 is already installed"

       else
       sudo apt install -y --reinstall apache2 apache2-bin
       fi
    fi
}

installApache2(){
    sudo apt install -y --reinstall apache2 apache2-bin
    STATUSAPACHE2=$?
    if [ $STATUSAPACHE2 -ne 0 ]
    then
        echo "ERROR: apache2 not installed"
        exit
    else
        echo "apache2 is successfull installed..."
        systemctl start apache2
    fi
}

checkApache2Status(){

     ISTATUS=$(systemctl status apache2)
     if [[ "$ISTATUS" = *"dead"* ]]
     then
        echo "ERROR: apache2 is not running.."
        systemctl start apache2
        echo "Apache2 is running"
           
      else
        echo "Apache2 is running..."

      fi
}
 
createConf(){
    if [ ! -e "/etc/apache2/sites-available/$domainName.conf" ]
    then
        touch /etc/apache2/sites-available/$domainName.conf
        cat script-template > /etc/apache2/sites-available/$domainName.conf
        sed -i -e 's/:server/'$domainName/'' /etc/apache2/sites-available/$domainName.conf
        sed -i -e 's/:dirloc/'$domainName/'' /etc/apache2/sites-available/$domainName.conf
        echo "$domainName.conf file created successfully......"
    else
        echo "$domainName.conf already exist"
    fi

}

copyDomain(){

    if [[ ! -e "/var/www/$domainName" ]]
    then
        cp -r $directoryLocation /var/www/$domainName
        echo "Copied sucessfull"
    else
        echo "$domainName already exist"
    fi
}

hostSite(){

    hostStatus=$(cat /etc/hosts)
    if [[ ! "$hostStatus" = *"$domainName"* ]]
    then
        echo -e "\n127.0.0.1  $domainName" >> /etc/hosts
        echo "added successfull"
        a2ensite $domainName
        status=$?
            if [ $status == 0 ]
            then 
                echo "$domainName hosted sucessfully"
                sudo systemctl reload apache2
            fi
    else
        echo "Domain already exist"
        a2ensite $domainName
        sudo systemctl reload apache2
        echo "Reload Sucessfull"
    fi
}

checkArgs $@
domainName=$1
directoryLocation=$2
checkSudo
checkApache2Exist
#installApache2
checkApache2Status
createConf
copyDomain
hostSite