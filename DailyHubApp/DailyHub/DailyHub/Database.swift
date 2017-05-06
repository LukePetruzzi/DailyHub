//
//  Database.swift
//  DailyHub
//
//  Created by Joe Salter on 4/3/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS
import AWSCognito

class Database {
    
    class func getDatabaseInfo(completionHandler:@escaping (String?, NSError?) -> ())
    {
        let dynamodb = AWSDynamoDB.default()
        let req = AWSDynamoDBGetItemInput()
        req?.tableName = "MainStorageFeed"
        let value:AWSDynamoDBAttributeValue = AWSDynamoDBAttributeValue()
        // this needs to be the current date in ISO
        value.s = getFormattedESTDate()
        req?.key = ["Date":value]
        
        dynamodb.getItem(req!).continueWith { (task) -> Any? in
            if task.error != nil {
                completionHandler(nil, task.error as NSError?)
                return nil
            }
            let output = task.result!.item
            completionHandler(output?.values.first?.s, nil)
            return nil
        }
        
    }
    
    class func getFormattedESTDate() -> String{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    class func getFormattedESTDateAndTime() -> String{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSSS"
        return formatter.string(from: Date())
    }

    
}
