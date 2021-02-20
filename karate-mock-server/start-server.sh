#!/bin/bash

echo "** Mock Server is now running **"
echo "Port : " $PORT
echo "Script : " $SCRIPT

# To see the help options ...
# java -jar karate.jar -h
java -jar karate.jar --mocks /karate/$SCRIPT --port $PORT --watch