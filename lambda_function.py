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
    masterJsonString = json.dumps(masterDictionary, indent=4, sort_keys=True)

    # json.dumps() converts a dictionary to str object, json.loads() converts the str back to a dictionary

    print(masterJsonString)
    print("MASTER DICTIONARY WAS UPDATED AT: " + str(datetime.datetime.now()))
    sys.stdout.flush()

    dynamodb = boto3.resource('dynamodb', region_name='us-west-2', endpoint_url="https://dynamodb.us-west-2.amazonaws.com")

    table = dynamodb.Table('MasterFeed')

    update = 12

    # update the dynamoDb table
    # just tried adding the actual dictionary instead of the string
    try:
        response = table.put_item(
            Item=
            {
                'UpdateId': "12",
                'dictionary': masterDictionary
            }
        )
        print("PutItem succeeded:")
        # print the response from dynamodb
        print(json.dumps(response, indent=4, cls=DecimalEncoder))

    except ClientError as e:
        print("ERROR, MOTHABROTHAAAA!!!")
        print(e.response['Error']['Message'])

lambda_handler(12,12)