#!/bin/bash

echo "${my_name}"
"sudo chown -R 1000:1000 '/home/ubuntu/.npm'"
cd /home/ubuntu/app
npm install
pm2 start app.js
"nodejs seeds/seed.js"
