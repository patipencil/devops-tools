#!/bin/bash

#######################################################################
######################### Feature Function Code #######################
#######################################################################


function cleanAndDeleteOldListedRepos {
	
	sudo killall apt apt-get
	sudo rm /var/lib/apt/lists/lock
	sudo rm /var/cache/apt/archives/lock
	sudo rm /var/lib/dpkg/lock*
	sudo dpkg --configure -a

}

function installJava {

	echo "installing java-11"

	sudo apt-get install openjdk-11-jre-headless -y

}


function downloadRequiredRepos {

	echo "Downloading packages for debian"

	wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

	echo "modifying apt file"
	sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

}


function installJenkins {

	echo "Updating packages"

	sudo apt-get update -y

	echo "Installing jenkins"

	sudo apt-get install jenkins -y

	echo "Congratulations your jenkins is ready .. "
	echo "Please login using following password .."
	cat /var/lib/jenkins/secrets/initialAdminPassword

}


function createJenkinsUser {

	sudo apt-get update -y
	
	echo "Creating jenkins user"

	sudo useradd -m -d /var/lib/jenkins -s /bin/bash -G sudo jenkins 

	echo "making jenkins as sudo user"

	sudo usermod -aG sudo jenkins

	nopasswdEntry=`cat /etc/sudoers | grep 'jenkins' | wc -l`

	if [[ $nopasswdEntry -eq 0 ]];then
	        echo "Making nopasswd entry in sudoers file"
	        echo 'jenkins  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers  
	fi

}


#######################################################################
############################# Main Function ###########################
#######################################################################

createJenkinsUser

cleanAndDeleteOldListedRepos

installJava

downloadRequiredRepos

installJenkins