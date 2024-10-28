# Spin up a SQL Server container
# FROM mcr.microsoft.com/mssql/server:latest as db

# ENV ACCEPT_EULA=Y
# ENV MSSQL_SA_PASSWORD=ECSd@shb0ard

# EXPOSE 1433

# CMD ["/opt/mssql/bin/sqlservr"]

#Build Stage
FROM bitnami/dotnet-sdk:latest AS builder

ENV SQLPROJ_NAME=TestSDKStyleSqlProj
ENV SQL_CONTAINER_NAME=sqlserver
ENV SQL_PASS=NotTheRightPassword


RUN dotnet tool install --global microsoft.sqlpackage
ENV PATH="$PATH:/app/.dotnet/tools"

WORKDIR /src
COPY . .

RUN dotnet restore
RUN dotnet build -p:NetCoreBuild=true --output=./dac/

CMD sqlpackage \
/Action:publish \
/SourceFile:"./dac/${SQLPROJ_NAME}.dacpac" \
/TargetServerName:"${SQL_CONTAINER_NAME},1433" \
/TargetDatabaseName:"master" \
/TargetUser:"sa" \
/TargetPassword:"${SQL_PASS}" \
/TargetEncryptConnection:Optional \
/p:CommandTimeout=30