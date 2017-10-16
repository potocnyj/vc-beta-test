# Simple script to generate a bunch of points in the telemetry database.

pwd

echo "Setting up database schema..."
mysql < test/init.sql

echo "Loading data..."
for i in `seq 1 1000`
do
	mysql -e "INSERT INTO telemetry.points (counter, ts, value) VALUES (1, $i, FLOOR(RAND() * 1000));"
done

echo "Done."
