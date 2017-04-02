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
    
    @IBOutlet weak var getFreshButton: UIButton!

    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFreshButton.addTarget(self, action: #selector(ViewController.getDatabaseInfo(_:)), for: .touchDown)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func getDatabaseInfo(_ button: UIButton)
    {
        
        
        let dynamodb = AWSDynamoDB.default()
        let req = AWSDynamoDBGetItemInput()
        req?.tableName = "MainStorageFeed"
        let value:AWSDynamoDBAttributeValue = AWSDynamoDBAttributeValue()
        // this needs to be the current date in ISO
        value.s = getFormattedESTDate()
        req?.key = ["Date":value]
        
        dynamodb.getItem(req!).continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error occurred: \(error)")
                return nil
            }
            let output = task.result!.item
            print("VALUE: ",output?.values.first?.s ?? "TABLE VALUE DOES NOT EXIST OR TABLE IS EMPTY!!!")
            
            self.count += 1
            print("COUNT: ", self.count)
            return nil
        }
        
        
    }
    
    private func getFormattedESTDate() -> String{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        // Eastern Standard Time
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "EST")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }


}

