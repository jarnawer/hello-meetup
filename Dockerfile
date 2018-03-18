#Stage 1: Build
FROM microsoft/aspnetcore-build AS builder
LABEL Name=hellomeetup Version=0.0.1
WORKDIR /app

COPY ./angular/*.csproj ./
RUN dotnet restore

RUN npm cache clean
RUN npm install -g n
RUN n stable
RUN node -v
RUN npm -v

COPY ./angular .
RUN dotnet publish --output /app/ --configuration Release

#Stage 2:Copy image from builder
FROM microsoft/aspnetcore
WORKDIR /app
COPY --from=builder /app .

ENV NODE_VERSION 9.3.0
ENV NODE_DOWNLOAD_URL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz

RUN curl -SL "$NODE_DOWNLOAD_URL" --output nodejs.tar.gz \    
    && tar -xzf "nodejs.tar.gz" -C /usr/local --strip-components=1 \
    && rm nodejs.tar.gz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENTRYPOINT [ "dotnet", "angular.dll" ]


 