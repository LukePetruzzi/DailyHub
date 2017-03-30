#!/bin/sh

# install required packages in this directory
pip install --upgrade requests -t ./

rm AWSLambdaPackage.zip
# create a zip file of the current directory to upload to AWS
zip -r ./AWSLambdaPackage.zip * -x \*.pyc \*.sh test\* \*DailyHubApp\*

# upload the deployment package to the Lambda function
aws lambda update-function-code --function-name UpdateMasterDictionaryPeriodically --zip-file fileb://AWSLambdaPackage.zip