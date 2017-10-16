#!/bin/sh

# Ensure the environment's MySQL server is configured correctly
# for VC Test to capture complete information. Currently this
# means ensuring that the slow-query log is enabled, and that the
# 'long_query_time' variable is set to 0 so we capture all queries.


# We need to make sure the server has the slow-query log
# set to capture all queries, and we need to capture the name of the logfile.
# We can do this by connecting to the DB and setting the vars dynamically.
#
# Start by fetching the slow_log location.
slow_log_file=`mysql -ss -e "select @@slow_query_log_file;"`
datadir=""
if [[ $slow_log_file == /* ]]
then
    echo "$slow_log_file is an absolute path"
else
    echo "$slow_log_file is a relative path, fetch the datadir to build the absolute path"
    datadir=`mysql -ss -e "select @@datadir;"`
    slow_log_file=`echo $datadir | sed 's/\/$//'`/`echo $slow_log_file | sed 's/^[\.\/]*//'`
    echo "Absolute path: $slow_log_file"
fi

# We need to store the slow_log path for vc-test-run to use,
# drop a reference to it in the current directory.
echo "$slow_log_file" > .slow_path

# Turn on the slow_query_log.
mysql -ss -e "SET GLOBAL slow_query_log=1;"

# Set the long_query_time to 0 last so we don't record our own queries.
mysql -ss -e "SET GLOBAL long_query_time=0;"
