#!/usr/bin/env bash
source .env

DB_URL="https://github.com/Microsoft/"`
	`"sql-server-samples/releases/download/"`
	`"adventureworks/AdventureWorks2016.bak"

read -r -d '' QUERY<< "EOF"
RESTORE DATABASE AdventureWorks2016 
	FROM DISK = "/var/opt/mssql/backup/AdventureWorks2016.bak" 
		WITH MOVE "AdventureWorks2016_Data" 
			TO "/var/opt/mssql/data/AdventureWorks2016_Data.mdf", 
		MOVE "AdventureWorks2016_Log" 
			TO "/var/opt/mssql/data/AdventureWorks2016_Log.ldf";
EOF

docker exec -it mssql  \
	sh -c "wget --directory-prefix=/var/opt/mssql/backup/ $DB_URL"
docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost \
	-U SA -P $SA_PASSWORD \
	-Q "$QUERY" 
