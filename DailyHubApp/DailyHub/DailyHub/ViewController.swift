//
//  ViewController.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 3/24/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS
import AWSCognito

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDatabaseInfo()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getDatabaseInfo()
    {
//        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
//        
//        dynamoDBObjectMapper.load(AnyObject.self, hashKey: "12", rangeKey: nil).continueWith(block: {(task:AWSTask<AnyObject>!) -> Any? in
//            if let error = task.error as? NSError {
//                print("The request failed. Error: \(error)")
//            } else if let resultEntry = task.result as? String {
//                // Do something with task.result.
//                print(resultEntry.dictionary ?? "FUCKERS")
//            }
//            else{
//                print("SHIT DIDN'T WORK")
//            }
//            return nil
//        })
        
//        let listTableInput = AWSDynamoDBListTablesInput()
//        
//        dynamodb.listTables(listTableInput!).continueWith { (task) -> Any? in
//            if let error = task.error {
//                print("Error occurred: \(error)")
//                return nil
//            }
//            let listTablesOutput = task.result!
//            
//            for tableName in listTablesOutput.tableNames! {
//                print("\(tableName)")
//            }
//            return nil
//        }
        
        let dynamodb = AWSDynamoDB.default()
        let req = AWSDynamoDBGetItemInput()
        req?.tableName = "MasterFeed"
        let value:AWSDynamoDBAttributeValue = AWSDynamoDBAttributeValue()
        value.s = String(12)
        req?.key = ["UpdateId":value]
        
        dynamodb.getItem(req!).continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error occurred: \(error)")
                return nil
            }
            let output = task.result!.item!
            for (k,v) in output{
                print("VALUE: ",v.s!)
            }
            
            
//            for (_,v) in output{
//                let m = v.m!
//                for (k,value) in m {
//                    print("KEY: \(k) = VALUE: \(value)")
//                }
//            }
//            
//            print("RESULT: ", output ?? 0)
            
//            let dictOutput = task.result!.dictionaryValue
//            for (k, list) in dictOutput!{
//                for map in list as Array{
//                    print
//                }
//            }
            
            return nil
        }
        
        
    }


}

