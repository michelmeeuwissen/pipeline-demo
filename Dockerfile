# Builder image
FROM registry.access.redhat.com/ubi8/nodejs-16 as builder
COPY . .
USER root
RUN npm install && npm run build

FROM registry.access.redhat.com/ubi8/nginx-120

USER root
RUN chown -R 1001:1001 /usr/share/nginx/html
USER 1001

COPY ./docker/nginx/default.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /opt/app-root/src/dist/pipeline-demo .

ENTRYPOINT ["nginx", "-g", "daemon off;"]
