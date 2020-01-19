#!/bin/bash
CI_BUILDS () {
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
  	tar -cvf $project_$branch-$buildtype-$buildNo.zip ./webapp/target/*.war

  	curl -u 'admin:38920139' -XPUT "http://35.154.161.74:8081/artifactory/CI-BUILDS/" -T $project_$branch-$buildtype-$buildNo.zip

  	rm -rf ./$project_$branch-$buildtype-$buildNo.zip

  else
    	echo "unable to push arifact bcz of build failure"
fi

}
Nightly_BUILD () {
echo "start the build"

mvn clean package

status=$?

if [ $status == 0 ]

  then
  	echo "start nightly build"
    
    project=wezva;
    branch=$(git rev-parse --abbrev-ref HEAD)
    buildtype=$JOB_NAME
    buildNo=$BUILD_NUMBER
  	tar -cvf $project_$branch-$buildtype-$buildNo.zip ./webapp/target/*.war

  	curl -u 'admin:38920139' -XPUT "http://35.154.161.74:8081/artifactory/nightly-BUILDS/" -T $project_$branch-$buildtype-$buildNo.zip

  	rm -rf ./$project_$branch-$buildtype-$buildNo.zip

  else
    	echo "unable to push arifact bcz of build failure"
fi

}


if [ $1 == CI_BUILDS ] ;
  then
  	CI_BUILD
  else
    Nightly_BUILD
fi
