# A local SQL server testing setup for data engineering

*Date:* 2025-05-16  
*Author:* MvS  
*keywords:* software-architecture, docker-compose, SQL server

## Description

This repo provides the preparation for local deployment of two different SQL server instances for training/testing purposes.
Main uses cas e is to migrate data from a historic instance to a newer instance an perform some data integrity testing.

## Running the Docker compose pipeline

1. Copy `.env.dist` to `.env` (no adjustments required / for future use with credentials)
2. Run `make run-compose` and let the containers for the stack come online.
3. Use <kbd>CTRL</kbd>+<kbd>C</kbd> to shut down the stack
4. Invoke `make clean` to remove the stack

### Manual access to container

Using compose:  
`docker-compose exec <container-name> env SAMPLEPAR="testing" bash`

Using docker:  
`docker exec -it <container-name> bash`

## SQL Server Setup

This stack includes two SQL Server 2022 instances:

- `sqlserver_historic`: Includes optional restore of sample databases
- `sqlserver_current`: Clean instance

### Configuration

All configuration is done via the `.env` file:

```dotenv
SA_PASSWORD=YourStrong!Passw0rd
SQLSERVER_HISTORIC_PORT=1434
SQLSERVER_CURRENT_PORT=1433
SQL_RESTORE_ON_START=true

To disable automatic restore, set SQL_RESTORE_ON_START=false.
Restore Databases

If SQL_RESTORE_ON_START is enabled, the following databases will be restored in sqlserver_historic:

    WideWorldImporters

    WideWorldImportersDW

You can also exec into the container and run /usr/src/app/restore-databases.sh manually.

On my machine the database restoration and upgrading on the historic instance takes about 15 min.

### ToDos

- add volumes for data persistence
- further tweaks for performance optimization
