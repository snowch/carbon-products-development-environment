#!/bin/bash
# --------------------------------------------------------------
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# --------------------------------------------------------------

set -e
set -x

########################################################################
# CEP Config


CEP_HOME=/home/vagrant/stratos/wso2cep-3.0.0/
STRATOS_DIR=/home/vagrant/stratos

CEP_URL=http://maven.wso2.org/nexus/content/groups/wso2-public/org/wso2/cep/wso2cep/3.0.0/wso2cep-3.0.0.zip

# this maven version of cep seems to be broken, so it must be downloaded from
# http://wso2.com/products/complex-event-processor/ and placed in /vagrant/downloads folder
#
# wget -nv -c -P /vagrant/downloads/ $CEP_URL
#
unzip -qq /vagrant/downloads/`basename ${CEP_URL}` -d $STRATOS_DIR

sed -i 's/<Offset>0/<Offset>4/g' ${CEP_HOME}/repository/conf/carbon.xml

wget -nv -c \
    -P ${CEP_HOME}/repository/conf/ \
    https://raw.github.com/apache/incubator-stratos/master/extensions/cep/artifacts/streamdefinitions/stream-manager-config.xml

# Update JNDI Properties

cat <<- EOF > ${CEP_HOME}/repository/conf/jndi.properties
	connectionfactory.topicConnectionfactory = amqp://admin:admin@clientID/carbon?brokerlist='tcp://localhost:5677'&reconnect='true'
	connectionFactoryNames = connectionfactory, topicConnectionfactory
	topic.lb-stats = lb-stats
	topic.instance-stats = instance-stats
	topic.summarized-health-stats = summarized-health-stats
EOF

# Update Siddhi Extensions

cat <<- EOF > ${CEP_HOME}/repository/conf/siddhi/siddhi.extension
	org.apache.stratos.cep.extension.GradientFinderWindowProcessor
	org.apache.stratos.cep.extension.SecondDerivativeFinderWindowProcessor
	org.apache.stratos.cep.extension.FaultHandlingWindowProcessor
EOF

# Update Siddhi jar

cp -f /home/vagrant/.m2/repository/org/apache/stratos/org.apache.stratos.cep.extension/1.0.0-SNAPSHOT/org.apache.stratos.cep.extension-1.0.0-SNAPSHOT.jar \
  ${CEP_HOME}/repository/components/lib/

#####################################################################
# This utility function retrieves files from github
#
# func relies on folder_name and file_names variables being populated
#
function get_artifacts 
{

   git_dir=https://github.com/apache/incubator-stratos/raw/4.0.0-incubating-m5/extensions/cep/artifacts/${folder_name}
      
   for item in ${file_names[*]}
   do
      git_file=${git_dir}/${item}
      dst_dir=$CEP_HOME/repository/deployment/server/${folder_name}/ 

      echo "Getting ${git_file}"
      wget -nv -c -P ${dst_dir} ${git_file}
   done

}

folder_name="eventbuilders"
file_names=(
   HealthStatisticsEventBuilder.xml
   InstanceStatusStatisticsBuilder.xml
   LoadBalancerStatisticsEventBuilder.xml
)
get_artifacts 

folder_name="inputeventadaptors"
file_names=( DefaultWSO2EventInputAdaptor.xml )
get_artifacts 

folder_name="outputeventadaptors"
file_names=( DefaultWSO2EventOutputAdaptor.xml )
get_artifacts 

folder_name="executionplans"
file_names=(
  AverageHeathRequest.xml
  AverageInFlightRequestsFinder.xml
  GradientOfHealthRequest.xml
  GradientOfRequestsInFlightFinder.xml
  SecondDerivativeOfHealthRequest.xml
  SecondDerivativeOfRequestsInFlightFinder.xml 
)
get_artifacts 

folder_name="eventformatters"
file_names=(
  AverageInFlightRequestsEventFormatter.xml
  AverageLoadAverageEventFormatter.xml
  AverageMemoryConsumptionEventFormatter.xml
  FaultMessageEventFormatter.xml
  GradientInFlightRequestsEventFormatter.xml
  GradientLoadAverageEventFormatter.xml
  GradientMemoryConsumptionEventFormatter.xml
  MemberAverageLoadAverageEventFormatter.xml
  MemberAverageMemoryConsumptionEventFormatter.xml
  MemberGradientLoadAverageEventFormatter.xml
  MemberGradientMemoryConsumptionEventFormatter.xml
  MemberSecondDerivativeLoadAverageEventFormatter.xml
  MemberSecondDerivativeMemoryConsumptionEventFormatter.xml
  SecondDerivativeInFlightRequestsEventFormatter.xml
  SecondDerivativeLoadAverageEventFormatter.xml
  SecondDerivativeMemoryConsumptionEventFormatter.xml
)
get_artifacts 
