#!/usr/bin/env bash
source .env

DB_URL="https://github.com/Microsoft/"`
	`"sql-server-samples/releases/download/"`
	`"adventureworks/AdventureWorks2016.bak"

DB_NAME="AdventureWorks2016"
DB_PATH='"/var/opt/mssql/backup/AdventureWorks2016.bak"'
DB_DATA='"AdventureWorks2016_Data"'
DB_DATA_PATH='"/var/opt/mssql/data/AdventureWorks2016_Data.mdf"'
DB_LOG='"AdventureWorks2016_Log"'
DB_LOG_PATH='"/var/opt/mssql/data/AdventureWorks2016_Log.ldf"'

read -r -d '' QUERY<<EOF
RESTORE DATABASE $DB_NAME 
	FROM DISK = $DB_PATH 
	WITH MOVE $DB_DATA 
	TO $DB_DATA_PATH,
	MOVE $DB_LOG 
	TO $DB_LOG_PATH;
EOF

docker exec -it mssql  \
	sh -c "wget --directory-prefix=/var/opt/mssql/backup/ $DB_URL"
docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost \
	-U SA -P $SA_PASSWORD \
	-Q "$QUERY" 
