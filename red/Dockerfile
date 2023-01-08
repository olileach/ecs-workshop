FROM nginx
EXPOSE 80
RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y curl && \
  cd /tmp && \
  apt-get install awscli -y && \
  rm -rf /tmp/* && \
  rm -rf /var/lib/apt/lists/*
COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /usr/share/nginx/html/red
COPY ./index.html /usr/share/nginx/html/red/index.html
CMD nginx -g "daemon off;"