#!/bin/bash

yum -y update && yum install -y python3 python3-pip git mesa-libGL htop
mkdir -p /app && cd /app
if [ ! -d "clinically" ]; then
    git clone https://github.com/tanishgoyal07/clinically.git
else
    cd /app/clinically && git pull origin main
fi
cd /app/clinically/backend
mkdir -p /var/tmp
TMPDIR=/var/tmp pip3 install --no-cache-dir -r requirements.txt
nohup python3 app.py > /app/backend.log 2>&1 &
