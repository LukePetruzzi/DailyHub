#!/bin/bash

# install required packages in this directory
pip install --upgrade requests -t ./

# create a zip file of the current directory to upload to AWS
zip -r ./AWSLambdaPackage.zip *

# upload the deployment package to the Lambda function
aws lambda update-function-code --function-name UpdateMasterDictionaryPeriodically --zip-file fileb://AWSLambdaPackage.zip