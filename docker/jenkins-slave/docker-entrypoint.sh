#!/usr/bin/env bash



if [ $# -eq 1 ]; then

  # if `docker run` only has one arguments, we assume user is running alternate command like `bash` to inspect the image
  exec "$@"

else
  echo "Running jenkins with user/groups/folder: " $(whoami) $(groups) $(pwd)
  if [ ! -z "$JENKINS_URL" ]; then
    curl --url $JENKINS_URL/jnlpJars/slave.jar  --output /data/slave.jar
    echo "Jenkins jar $JENKINS_URL/jnlpJars/slave.jar downloaded"
  fi

  # if -tunnel is not provided try env vars
  if [[ "$@" != *"-tunnel "* ]]; then
    if [ ! -z "$JENKINS_TUNNEL" ]; then
      TUNNEL="-tunnel $JENKINS_TUNNEL"
    fi
  fi
  
  if [ ! -z $JENKINS_SECRET ] && [ ! -z $JENKINS_JNLP_URL ]; then
  	echo "Running Jenkins JNLP Slave...."
 	URL="-jnlpUrl $JENKINS_JNLP_URL"
 	SECRET="-secret $JENKINS_SECRET"
  fi


  exec java $JAVA_OPTS $JNLP_PROTOCOL_OPTS -jar /data/slave.jar $TUNNEL $URL $SECRET
fi