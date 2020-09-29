FROM node:12.18.4 AS compile-image

WORKDIR /opt/ng
COPY package.json ./
RUN npm install

ENV PATH="./node_modules/.bin:$PATH"

COPY . ./
RUN ng build --prod

FROM nginx:1.18
RUN cp docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=compile-image /opt/ng/dist/pipeline-demo /usr/share/nginx/html

RUN chown -R 1001:1001 /var/cache/nginx/client_temp

USER 1001
