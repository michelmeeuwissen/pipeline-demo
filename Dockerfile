FROM node:13.3.0 AS compile-image

ARG workingDir="$PWD"

RUN npm install
RUN npm run build

FROM nginx
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=compile-image $workingDir/dist/pipeline-demo /usr/share/nginx/html
