#!/bin/bash
CI-BUILDS () {
echo "start the build"

mvn package

status=$?

if [ $status == 0 ]

  then
  	echo "start ci build"
    

         project=wezva;
         testing=$GIT_BRANCH
         echo "$testing" > test1.txt
         branch=$(cat test1.txt |sed 's/\//-/g' )
         buildtype=$JOB_NAME
         buildNo=$BUILD_NUMBER
  	 tar -cvf $project\/$branch\/$buildtype\/$buildNo.zip ./webapp/target/*.war

  	 curl -u 'admin:38920139' -XPUT "http://35.154.161.74:8081/artifactory/CI-BUILDS/" -T $project\/$branch\/$buildtype\/$buildNo.zip

  	 rm -rf ./$project\/$branch\/$buildtype\/$buildNo.zip

  else
    	echo "unable to push arifact bcz of build failure"
fi

}

Nightly-BUILDS () {

echo "start the build"

mvn clean package

status=$?

if [ $status == 0 ]

  then
  	echo "start nightly build"
    
        project=wezva;
        testing=$GIT_BRANCH
        echo "$testing" > test1.txt
        branch=$(cat test1.txt |sed 's/\//-/g' )
        buildtype=$JOB_NAME
        buildNo=$BUILD_NUMBER
        tar -cvf $project_$branch_$buildtype_$buildNo.zip ./webapp/target/*.war

    curl -u 'admin:38920139' -XPUT "http://35.154.161.74:8081/artifactory/Nightly-BUILDS/" -T $project_$branch_$buildtype_$buildNo.zip

        rm -rf ./$project_$branch_$buildtype_$buildNo.zip

  else
    	echo "unable to push arifact bcz of build failure"
fi

}


if [ $1 == CI-BUILDS ] ;
  then
  	CI-BUILDS
  else
    Nightly_BUILD
fi
