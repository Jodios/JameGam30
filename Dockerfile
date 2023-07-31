FROM nginx:alpine

COPY Wrenchman.html /usr/share/nginx/html/index.html
COPY Wrenchman* /usr/share/nginx/html
