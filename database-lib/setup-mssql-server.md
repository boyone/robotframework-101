# Setup MsSql Server

## Start MsSql Server

```sh
docker container run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=myP@ssw0rd' -p 1433:1433 -d --name mssql -h mssql mcr.microsoft.com/mssql/server:2019-CU12-ubuntu-20.04
```

### Environment Variables

- `ACCEPT_EULA` confirms your acceptance of the End-User Licensing Agreement.
- `SA_PASSWORD` is the database system administrator (userid = 'sa') password used to connect to SQL Server once the container is running. Important note: This password needs to include at least 8 characters of at least three of these four categories: uppercase letters, lowercase letters, numbers and non-alphanumeric symbols.
- `MSSQL_PID` is the Product ID (PID) or Edition that the container will run with. Acceptable values:
  - Developer : This will run the container using the Developer Edition (this is the default if no MSSQL_PID environment variable is supplied)
  - Express : This will run the container using the Express Edition
  - Standard : This will run the container using the Standard Edition
  - Enterprise : This will run the container using the Enterprise Edition
  - EnterpriseCore : This will run the container using the Enterprise Edition Core

## Connect DB

```sh
docker exec -it mssql bash
```

```sh
ls /opt/mssql-tools/bin/
# bcp sqlcmd
```

```sh
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "myP@ssw0rd"
```

### Create a new database

- create a test database

```sh
CREATE DATABASE TestDB
```

- query to return the name of all of the databases on your server

```sh
SELECT Name from sys.Databases
```

- Type GO on a new line to execute the previous commands

```sh
GO
```

- switch context to the new `TestDB` database

```sh
USE TestDB
```

- Create new table name Inventory

```sh
CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)
```

- Insert data into the new table

```sh
INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
```

- Type `GO` to execute the previous commands

```sh
GO
```

- Select data

```sql
select * from Inventory
```

- Type `GO` to execute the previous commands

```sh
GO
```

## Dump Database

- Run Container

```sh
docker container run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=myP@ssw0rd' -p 1433:1433 -d --name mssql -h mssql -v `pwd`/init: -w /usr/src/app/ mcr.microsoft.com/mssql/server:2019-CU12-ubuntu-20.04
```

- Create `setup.sql` to Create Database and Tables

```sql
CREATE DATABASE inventory;
GO
USE inventory;
GO
CREATE TABLE products (id int, name nvarchar(max));
GO
```

- Create `products.csv`

```csv
1,Car
2,Truck
3,Motorcycle
4,Bicycle
5,Horse
6,Boat
7,Plane
8,Scooter
9,Skateboard
```

- Run `sqlcmd`

```sh
docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P myP@ssw0rd -d master -i setup.sql
```

- Run `bcp`

```sh
docker exec -it mssql /opt/mssql-tools/bin/bcp inventory.dbo.products in products.csv -c -t',' -S localhost -U sa -P myP@ssw0rd
```

---

## References

- [https://github.com/twright-msft/mssql-node-docker-demo-app](https://github.com/twright-msft/mssql-node-docker-demo-app)
