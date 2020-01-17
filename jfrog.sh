#!/bin/bash

echo "start the build"

mvn package

status=$?

if [ $status == 0 ]

  then
  	echo "start ci build"
    
    project=wezva;
    branch=$(git rev-parse --abbrev-ref HEAD)
    buildtype=$JOB_NAME
    buildNo=$BUILD_NUMBER
  	tar -cvfz $project_$branch_$buildtype_$buildNo_.tar.gz ./webapp/target/*.war

  	curl -u 'admin:38920139' -XPUT "http://13.233.99.57:8081/artifactory/CI-BUILDS/" -T $project_$branch_$buildtype_$buildNo_.tar.gz

  	rm -rf ./target

else
	echo "this is artifactory niku ardhamavthundha"
fi
