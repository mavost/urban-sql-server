# syntax=docker/dockerfile:1
# based on
# https://docs.docker.com/compose/gettingstarted/
# and some housekeeping

ARG BASEIMAGE=mcr.microsoft.com/mssql/server:2022-latest
FROM ${BASEIMAGE}

ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Developer

USER root

# Create backup folder and set permissions
RUN mkdir -p /var/opt/mssql/backup && chown -R mssql /var/opt/mssql

# Download sample databases
RUN apt-get update && apt-get install -y curl \
    && curl -L -o /var/opt/mssql/backup/WideWorldImporters-Full.bak https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak \
    && curl -L -o /var/opt/mssql/backup/WideWorldImportersDW-Full.bak https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImportersDW-Full.bak

# Copy restore script
COPY restore-databases.sh /usr/src/app/restore-databases.sh
RUN chmod +x /usr/src/app/restore-databases.sh

# Copy optimization script
COPY optimize-sqlserver.sh /usr/src/app/optimize-sqlserver.sh
RUN chmod +x /usr/src/app/optimize-sqlserver.sh

CMD /bin/bash -c "/opt/mssql/bin/sqlservr & \
   sleep 30 && \
   /usr/src/app/optimize-sqlserver.sh && \
   if [ \"$SQL_RESTORE_ON_START\" = \"true\" ]; then /usr/src/app/restore-databases.sh; fi && tail -f /dev/null"
