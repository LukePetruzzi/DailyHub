//
//  FeedViewController
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


class FeedViewController: UIViewController {
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.29, green: 0.29, blue:0.29, alpha: 1.0)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDatabaseInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getDatabaseInfo()
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

