#!/bin/bash

echo "export DB_HOST='mongodb://${db_priv_ip}:27017/posts'" >> /home/ubuntu/.bashrc
export DB_HOST='mongodb://${db_priv_ip}:27017/posts'
"sudo chown -R 1000:1000 '/home/ubuntu/.npm'"
cd /home/ubuntu/app
npm install
nodejs seeds/seed.js
npm start
