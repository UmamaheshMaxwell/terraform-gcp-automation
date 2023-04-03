sudo apt update -y 
sudo apt install apache2 git  -y 
sudo git clone  https://github.com/devopswithcloud/static-website.git
sudo rm -rf  /var/www/html/index.html
sudo cp -r static-website/* /var/www/html/