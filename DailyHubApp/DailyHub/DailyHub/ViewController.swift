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
            print("VALUE: ",output.values.first?.s ?? "TABLE IS EMPTY")
            
//            for (k,v) in output{
//                print("VALUE: ",v.s!)
//            }
            return nil
        }
        
        
    }


}

