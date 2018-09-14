#!/bin/bash
yum update -y
sudo yum install java-1.8.0-openjdk -y
sudo yum install epel-release -y
sudo yum install nginx -y
sudo yum install wget -y
wget https://s3-eu-west-1.amazonaws.com/glovo-public/systems-engineer-interview-1.0-SNAPSHOT.jar -O /home/ec2-user/systems-engineer-interview-1.0-SNAPSHOT.jar
sudo sed -i -e 's,SELINUX=enforcing,SELINUX=disabled,g' /etc/selinux/config 
sudo setenforce 0
sudo service firewalld stop
sudo sed -i -e 's,80,81,g' /etc/nginx/nginx.conf
echo "server {" > /etc/nginx/conf.d/glovoapp.conf 
echo "  listen 80;" >> /etc/nginx/conf.d/glovoapp.conf 
echo "  listen [::]:80;" >> /etc/nginx/conf.d/glovoapp.conf  
echo "  server_name glovo.com;" >> /etc/nginx/conf.d/glovoapp.conf  
echo "  location / {" >> /etc/nginx/conf.d/glovoapp.conf  
echo "      proxy_pass http://localhost:8080/;" >> /etc/nginx/conf.d/glovoapp.conf  
echo "      proxy_set_header X-Glovo-Systems-Engineer-Candidate ${magic_header};" >> /etc/nginx/conf.d/glovoapp.conf  
echo "  }" >> /etc/nginx/conf.d/glovoapp.conf  
echo "}" >> /etc/nginx/conf.d/glovoapp.conf  
java -jar /home/ec2-user/systems-engineer-interview-1.0-SNAPSHOT.jar server &
sleep 30
sudo service nginx start
