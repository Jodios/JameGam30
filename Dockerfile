FROM nginx:alpine

COPY Wrenchman.html /usr/share/nginx/html/index.html
COPY Wrenchman* /usr/share/nginx/html

COPY Wrenchman.html /etc/nginx/html/index.html
COPY Wrenchman* /etc/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf
#COPY nginx.conf /data/web/nginx/server.headers
