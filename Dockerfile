FROM registry.access.redhat.com/ubi8/nodejs-16 as builder

USER root
RUN chown -R 1001:1001 /opt/ng
USER 1001

WORKDIR /opt/ng
COPY package.json ./
RUN npm install

ENV PATH="./node_modules/.bin:$PATH"

COPY . ./
RUN ng build --prod

FROM registry.access.redhat.com/ubi8/nginx-120

USER root
RUN chown -R 1001:1001 /usr/share/nginx/html
USER 1001

COPY ./docker/nginx/default.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /opt/ng/dist/pipeline-demo .

ENTRYPOINT ["nginx", "-g", "daemon off;"]
