#!/bin/bash
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker ec2-user

echo "****************************************************"
echo "Docker running and ec2-user added to docker group."
echo "Log out and log back in, and then run ./build.sh."
echo "****************************************************"
