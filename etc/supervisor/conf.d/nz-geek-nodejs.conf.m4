[program:nz-geek-nodejs]
command = sudo -E -u chilts __NODE__ __PWD__/app.js
directory = /home/chilts/src/chilts-nodejs-geek-nz
user = __USER__
autostart = true
autorestart = true
stdout_logfile = /var/log/nz-geek-nodejs/stdout.log
stderr_logfile = /var/log/nz-geek-nodejs/stderr.log
environment = NODE_ENV="production"
