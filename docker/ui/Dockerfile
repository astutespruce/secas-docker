# Provides: User Interface Builder for South Atlantic and Southeast

FROM node:14-buster-slim

# install required libGL.so.1 for cwebp
RUN apt update && apt install -y libgl1-mesa-glx libxi6

RUN npm install -g npm@7.5 && \
    npm install -g gatsby-cli@2.19 && \
    gatsby telemetry --disable

WORKDIR /app
