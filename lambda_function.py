#!/usr/bin/env python2


from __future__ import print_function
from botocore.exceptions import ClientError
import masterDictMaker
import json
import sys
import datetime
import decimal
import boto3


# Helper class to convert a DynamoDB item to JSON.
class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if o % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)

# required function for the lambda function to run
def lambda_handler(json_input, context):

    masterDictionary = masterDictMaker.createMasterDict()

    # turn the json into a string object
    masterJsonString = json.dumps(masterDictionary, sort_keys=True)

    # json.dumps() converts a dictionary to str object, json.loads() converts the str back to a dictionary

    # print(masterJsonString)
    print("MASTER DICTIONARY WAS UPDATED AT: " + str(datetime.datetime.now()))
    sys.stdout.flush()

    dynamodb = boto3.resource('dynamodb', region_name='us-west-2', endpoint_url="https://dynamodb.us-west-2.amazonaws.com")
    table = dynamodb.Table('MainStorageFeed')

    # first, query to get the latest dynamoDB object.
    # just save each database entry as the latest date. yymmdd format?

    # the date in ISO 8601 format
    dateFormatted = datetime.datetime.now().strftime("%Y-%m-%d")

    # update the dynamoDb table
    # UpdateId is always 1 because single partition can hold 10GB of data, and 
    # we ain't storing that much data
    try:
        response = table.put_item(
            Item=
            {
                'Date': dateFormatted,
                'Dictionary': masterJsonString
            }
        )
        print("PutItem succeeded:")
        # print the response from dynamodb
        # print(json.dumps(response, indent=4, cls=DecimalEncoder))

    except ClientError as e:
        print("ERROR, MOTHABROTHAAAA!!!")
        print(e.response['Error']['Message'])

# lambda_handler(12,12)