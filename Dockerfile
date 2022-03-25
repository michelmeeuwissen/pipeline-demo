FROM node:16.14.2 as builder

WORKDIR /opt/ng
COPY package.json ./
RUN npm install

ENV PATH="./node_modules/.bin:$PATH"

COPY . ./
RUN ng build --prod

FROM registry.redhat.io/rhel8/nginx-118
RUN cp docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /opt/ng/dist/pipeline-demo /usr/share/nginx/html

RUN chown -R 1001:1001 /var/cache/nginx/client_temp

USER 1001
