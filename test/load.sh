# Simple script to generate a bunch of points in the telemetry database.

mysql < test/init.sql

for i in `seq 1 1000`
do
	mysql -e "INSERT INTO telemetry.points (id, ts, value) VALUES (1, $i, FLOOR(RAND() * 1000));"
done
