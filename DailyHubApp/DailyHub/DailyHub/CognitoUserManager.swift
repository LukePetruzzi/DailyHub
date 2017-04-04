//
//  CognitoUserController.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/3/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import AWSCognito

class CognitoUserManager
{
    // Can't init, is singleton
    private init() { }
    static let sharedInstance: CognitoUserManager = CognitoUserManager()
    
    // the sync client used to update the user data to the Cognito cloud
    private let syncClient = AWSCognito.default()
    
    func showAllDatasets()
    {
        for set in self.syncClient.listDatasets(){
            print("DATASET: ", set.name)
        }
    }

    
    func testDataSet(dataSetName: String)
    {
        let dataset = self.syncClient.openOrCreateDataset(dataSetName)
        
        dataset.setString("my value", forKey:"myKey")
        
        dataset.synchronize().continueWith(block: { (task) -> AnyObject? in
            
            if task.isCancelled {
                // Task cancelled.
            } else if task.error != nil {
                // Error while executing task
            } else {
                // Task succeeded. The data was saved in the sync store.
            }
            return task
        })
    }

    
}
