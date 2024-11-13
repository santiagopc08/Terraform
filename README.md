# Terraform
The commands used for Terraform deployment were:
```
terraform init
terraform plan
terraform apply
terraform destroy
```
Then, for connecting to the EC2 instance I used:
```
ssh -i "terraform.pem" ubuntu@ec2-100-26-207-110.compute-1.amazonaws.com
```
Once inside the instance:
```
#Update the system
sudo apt update && sudo apt upgrade -y
#Install nginx
sudo apt install -y nginx
#Start nginx
sudo systemctl start nginx
#Replace nginx home page
sudo rm /var/www/html/index.nginx-debian.html
echo '<!DOCTYPE html>
 <html lang="es">
 <head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>Página de Bienvenida</title>
     <style>
         body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
         h1 { color: #4CAF50; }
     </style>
 </head>
 <body>
     <h1>¡Hola Mundo!</h1>
     <p>Bienvenido a tu servidor web en AWS EC2 utilizando Nginx.</p>
</body>
</html>' | sudo tee /var/www/html/index.html
```
