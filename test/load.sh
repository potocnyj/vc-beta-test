# Simple script to generate a bunch of points in the telemetry database.
for i in `seq 1 1000`
do
	mysql -e "INSERT INTO POINTS (id, ts, value) VALUES (1, $i, FLOOR(RAND() * 1000));"
done