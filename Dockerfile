
FROM microsoft/aspnetcore:1
LABEL Name=hellomeetup Version=0.0.1
ARG source=.
WORKDIR /angular
EXPOSE 5000
COPY $source .
ENTRYPOINT dotnet hellomeetup.dll
