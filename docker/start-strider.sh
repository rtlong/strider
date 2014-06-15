#!/bin/bash

if [ -n "$DB_URI" ]; then
  MONGODB_URI=${DB_URI}
elif [ -z "$MONGODB_URI" ]; then
  MONGODB_URI=mongodb://localhost/strider-foss
fi
if [ -n "$MONGO_PORT" ]; then
  MONGODB_URI="mongodb://${MONGO_PORT#tcp://}/strider-foss"
fi
export DB_URI=$MONGODB_URI
# TODO: make this work with arbitrary plugin_* vars
export SERVER_NAME=$SERVER_NAME 
export SMTP_HOST=$SMTP_HOST 
export SMTP_USER=$SMTP_USER 
export SMTP_PASS=$SMTP_PASS 
export SMTP_FROM=$SMTP_FROM 
export PLUGIN_GITHUB_APP_ID=$PLUGIN_GITHUB_APP_ID 
export PLUGIN_GITHUB_SECRET=$PLUGIN_GITHUB_SECRET 
export NODE_ENV=production 
env

exec bin/strider $@
