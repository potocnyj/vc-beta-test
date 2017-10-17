#!/bin/sh

# Ensure the environment's MySQL server is configured correctly
# for VC Test to capture complete information. Currently this
# means ensuring that the slow-query log is enabled, and that the
# 'long_query_time' variable is set to 0 so we capture all queries.


# We need to make sure the server has the slow-query log
# set to capture all queries, and we need to capture the name of the logfile.
# We can do this by connecting to the DB and setting the vars dynamically.
#
# Start by setting the slow_log location;
# we'll set it to the current working directory for simplicity.
slow_log_location="`pwd`/slow.log"
touch slow.log
chmod 777 slow.log

# Set the slow path in the server.
mysql -ss -e "SET GLOBAL slow_query_log_file='$slow_log_location';"

# Turn on the slow_query_log.
mysql -ss -e "SET GLOBAL slow_query_log=1;"

# Set the long_query_time to 0 last so we don't record our own queries.
mysql -ss -e "SET GLOBAL long_query_time=0;"
