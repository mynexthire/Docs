#!/bin/bash

# ps -eo pid,cmd,tty,args | while read PID CMD TTY ARG; do echo $PID $CMD $TTY $ARG; done



echo "Stopping Jenkins...";
sudo service jenkins stop
echo "Stopped Jenkins...";

sleep 2;

ps -eo pid,cmd,tty,args | while read PID CMD TTY ARG;
do

#echo $PID $CMD $TTY $ARG;

#echo $ARG;

if [[ $ARG == *"/usr/bin/java -Djava.util.logging.config.file=/opt/tomcat/conf/logging.properties"* ]]; then
  #echo "Tomcat Process Id:$PID";
  echo "Stopping Tomcat...";
  sudo kill -9 $PID
  echo "Stopped Tomcat...";
fi

if [[ $ARG == *"java -Xms2048m -Xmx2048m -jar /home/ubuntu/mynexthire-github/SQSCore/target/SQSCore.jar"* ]] && ! [[ $ARG == *"sudo"*  ]] ; then
  #echo "QR Process Id:$PID";
  echo "Stopping QR...";
  sudo kill -9 $PID
  echo "Stopped QR...";

fi
done

if [ $1 ]; then
echo "Cleaning application logs...";
cd /home/ubuntu/WOWAppLogs
ls -l
sudo rm -r *;
ls -l
echo "Cleaned application logs...";
fi

echo "";

if [ $2 ]; then
echo "Cleaning tomcat logs...";
cd /opt/tomcat/temp
ls -l
sudo rm -r *;
ls -l
cd /opt/tomcat/logs
ls -l
sudo rm -r *;
ls -l
echo "Cleaned tomcat logs...";
fi

#sleep 10;

echo "Starting Tomcat...";
sudo service tomcat start
echo "Started Tomcat...";

echo "Waiting for Tomcat to warm-up[2 minutes]";
for i in {1..240}
do
  echo -n -e ".";
  sleep 0.5
done

echo ""
echo "Starting QR...";
sudo java -Xms2048m -Xmx2048m -jar /home/ubuntu/mynexthire-github/SQSCore/target/SQSCore.jar & disown
echo "Started QR...";


#echo "Starting Jenkins...";
#sudo service jenkins start
#echo "Started Jenkings..."

