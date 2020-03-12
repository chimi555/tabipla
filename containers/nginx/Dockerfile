FROM nginx
USER root
RUN rm -f /etc/nginx/conf.d/*
ADD nginx.conf /etc/nginx/conf.d/triplog.conf
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf