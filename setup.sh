#
#  Copyright 2010-2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#  This file is licensed under the Apache License, Version 2.0 (the "License").
#  You may not use this file except in compliance with the License. A copy of
#  the License is located at
# 
#  http://aws.amazon.com/apache2.0/
# 
#  This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#  CONDITIONS OF ANY KIND, either express or implied. See the License for the
#  specific language governing permissions and limitations under the License.
#
"#!/bin/bash"

clear
echo "Setting up environment - please wait."
export AWS_DEFAULT_OUTPUT="json"
export AWS_PAGER="" 
region=$(curl -s http://169.254.169.254/latest/meta-data/placement/region) 
account_id=$(aws sts get-caller-identity --query Account --output text)
echo ""
echo "Configuring Cloud9 instance for immersion day"
sudo yum install -y jq
echo ""
echo "Installing the latest version of the AWS Cli"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
echo "Unzipping awscliv2.zip to /tmp/cli"
unzip -o -q /tmp/awscliv2.zip -d /tmp/cli
echo "Updating AWS CLI using awscliv2.zip in /tmp/cli"
sudo /tmp/cli/aws/install --update
aws configure set default.region ${region}
aws ecr create-repository --repository-name main --image-scanning-configuration scanOnPush=false --image-tag-mutability MUTABLE --region ${region}
aws ecr create-repository --repository-name blue --image-scanning-configuration scanOnPush=false --image-tag-mutability MUTABLE --region ${region}
aws ecr create-repository --repository-name red --image-scanning-configuration scanOnPush=false --image-tag-mutability MUTABLE --region ${region}
cd ecsworkshop
docker build -t main main/.
docker build -t red red/.
docker build -t blue blue/.
echo "aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${region}.amazonaws.com
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${region}.amazonaws.com
docker tag main:latest ${account_id}.dkr.ecr.${region}.amazonaws.com/main:latest
docker push ${account_id}.dkr.ecr.${region}.amazonaws.com/main:latest
docker tag blue:latest ${account_id}.dkr.ecr.${region}.amazonaws.com/blue:latest
docker push ${account_id}.dkr.ecr.${region}.amazonaws.com/blue:latest
docker tag red:latest ${account_id}.dkr.ecr.${region}.amazonaws.com/red:latest
docker push ${account_id}.dkr.ecr.${region}.amazonaws.com/red:latest