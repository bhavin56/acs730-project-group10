#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo aws s3 cp s3://dev-acs730-project-group10/images /var/www/html/images --recursive #copy all the images in the images folder of bucket
#sudo aws s3 cp s3://dev-acs730-project-group10/images/cntower.jpeg /var/www/html/cntower.jpeg  #copy a single image
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<html>
  <head>
    <title>Group10 Webserver</title>
 </head>
 <body>
    <center>
        <h2>This webpage is created by</h2>
        <h1>${prefix}</h1>
        <h2>and the group members are</h2>
        <h1>${name}</h1>
        <h3>The private IP of the EC2 instance is $myip in ${env} environment</h3>
    </center>

    <table border="5" bordercolor="grey" align="center">
    <tr>
        <th colspan="3">PLACES TO VISIT IN ONTARIO</th> 
    </tr>
    <tr>
        <th>Niagara Falls</th>
        <th>CN Tower</th>
        <th>Tobermory</th>
    </tr>
    <tr>
        <td><img src="images/NiagaraFalls.jpeg" alt="" border=3 height=200 width=300></img></th>
        <td><img src="images/cntower.jpeg" alt="" border=3 height=200 width=300></img></th>
        <td><img src="images/tobermory.jpeg" alt="" border=3 height=200 width=300></img></th>
    </tr>
    </table>
  </body>
<html>" > /var/www/html/index.html