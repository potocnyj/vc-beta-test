#!/bin/sh

getBinary() {
    curl -L -s "$1" > ~/bin/$2
    chmod +x ~/bin/$2
}

binaryURI="https://s3.amazonaws.com/vc-test-dev"

# Download our command-line tools.
getBinary "$binaryURI/vc-mysql-parse" vc-mysql-parse
getBinary "$binaryURI/vc-aggregate" vc-aggregate
getBinary "$binaryURI/cmd-checker" cmd-checker

# Set environment variables somewhat naively.
# We should have the VC_API_TOKEN parameter set in the environment our script runs in.
#
# These params will probably be constant; they are controlled by VC.
export VC_API_URI=https://app.vividcortex.com/api/v2
export VC_BUCKET="vc-test-data"

# Additional params providing context on the PR/Commit we are testing.
# We're assuming a CircleCI environment here; in the future we may
# dynamically detect our environment and act accordingly.
export VC_COMMIT=$CIRCLE_SHA1
export VC_REPO=$CIRCLE_PROJECT_REPONAME
export VC_OWNER=$CIRCLE_PROJECT_USERNAME
export VC_PULL_ID=`basename $CI_PULL_REQUEST`
export VC_RUN=`basename $CIRCLE_BUILD_URL`

# Set database connection params so we can connect
# to the test DB and collect EXPLAIN plans for queries.
# We'll check if the user has set their own connection
# creds in the environment, and default to an assumed set if not.
#
# Check the user to connect as.
if [ ! -z "$DB_USER" ]
then
    export VC_DB_USER=$DB_USER
else
    # Assume root user if none provided.
    export VC_DB_USER="root"
fi

# Check if a password is needed for the user.
if [ ! -z "$DB_PASSWORD" ]
then
    export VC_DB_PASSWORD=$DB_PASSWORD
fi

# Check the host:port to connect to.
if [ ! -z "$DB_HOST" ]
then
    export VC_DB_HOST=$DB_HOST
else
    # Assume default localhost/port if not host addr provided.
    export VC_DB_HOST="localhost:3306"
fi

# Check if we should connect to a specific DB.
if [ ! -z "$DB_DATABASE" ]
then
    export VC_DB_DATABASE=$DB_DATABASE
fi

# Execute the analysis using the slow log passed into the script.
SLOW_LOG_PATH=$1
cat $SLOW_LOG_PATH | ~/bin/vc-mysql-parse | ~/bin/vc-aggregate

# The cmd-checker runs separately.
~/bin/cmd-checker

