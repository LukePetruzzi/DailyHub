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

    

    
    func retrieveUserSitePrefs(){
        print("ASS")
    }
    
    func convertJSONStringToSitePrefsArray(jsonString: String)
    {
        //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [AnyObject].
        if let data = jsonString.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                print("ACTUAL JSON: \(json)")
                
                
                var feedArray = [SitePref]()
                var output = [[SitePref]]()
                
                // need to understand how we are doing it in feedview and itll work
                for array in json{
                    for element in array{
                        let name = element["siteName"] as! String
                        let num = element["numPosts"] as! Int
                        
                        
                        let pref =
                    }
                    output.append(feedArray)
                    feedArray = [SitePref]()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func convertSitePrefsToJSONString(newPrefs: [[SitePref]]){
     
        
        // create in-feed array
        var inFeedArray: Array<String> = []
        for pref in newPrefs[0]{
            if let json = pref.toJSON() {
                inFeedArray.append(json)
            }
        }
        // create not-in-feed array
        var notInFeedArray: Array<String> = []
        for pref in newPrefs[1]{
            if let json = pref.toJSON() {
                notInFeedArray.append(json)
            }
        }
        
        let dict:[String:[String]] = ["inFeed":inFeedArray, "notInFeed:":notInFeedArray]
        
        // convert to json string
        do {
            //Convert to Data
            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print("JSON STRING:",JSONString)
                convertJSONStringToSitePrefsArray(jsonString: JSONString)

            }
            
            
            
        } catch {
            print(error.localizedDescription)
        }

        
    }
    
    func updateUserSitePrefs(newPrefs: [[SitePref]])
    {
        
        
        let dataset = self.syncClient.openOrCreateDataset("userSitePrefs")
        
        // set the value to be the double array of in feed or not in feed prefs
        // key is 0. so they can have many different feeds if they want
        dataset.setValue(newPrefs, forKey: "0")
        
        dataset.synchronize().continueWith(block: { (task) -> AnyObject? in
            
            if task.isCancelled {
                print("TASK CANCELLED WHEN ADDING NEW SITE PREFS")
            } else if task.error != nil {
                print("ERROR WHEN ADDING NEW SITE PREFS: \(task.error?.localizedDescription)")
            } else {
                // Task succeeded. The data was saved in the sync store.
            }
            return task
        })
    }
    
    func firstTimeUserCheckAndSetup()
    {
        // return if its been set up before
        for set in self.syncClient.listDatasets(){
            if (set.name == "hasSetUp")
            {
                return
            }
        }
        
        // set up for the first time
        let dataset = self.syncClient.openOrCreateDataset("hasSetUp")
        // doesn't matter whats stored in here
        dataset.setString("Anything", forKey: "AnythingElse")
        dataset.synchronize().continueWith(block: { (task) -> AnyObject? in
            
            if task.isCancelled {
                print("TASK CANCELLED WHEN ADDING hasSetUp dataset")
            } else if task.error != nil {
                print("ERROR WHEN ADDING hasSetUp dataset: \(task.error?.localizedDescription)")
            } else {
                // Task succeeded. The data was saved in the sync store.
            }
            return task
        })
        
        // create the first time user prefs (put in all the supported sites!
        let newSitePrefs = [[SitePref(siteName: "Giphy", numPosts: 1),
                              SitePref(siteName: "Buzzfeed", numPosts: 1),
                              SitePref(siteName: "Deviant", numPosts: 1),
                              SitePref(siteName: "ESPN", numPosts: 1),
                              SitePref(siteName: "IGN", numPosts: 1),
                              SitePref(siteName: "Imgur", numPosts: 1),
                              SitePref(siteName: "Soundcloud", numPosts: 1),
                              SitePref(siteName: "Techcrunch", numPosts: 1),
                              SitePref(siteName: "Vimeo", numPosts: 1),
                              SitePref(siteName: "YouTube", numPosts: 1)], // end of "inFeed" prefs
                            [SitePref(siteName: "500px", numPosts: 3),
                             SitePref(siteName: "AP", numPosts: 2),
                             SitePref(siteName: "BBCNews", numPosts: 5),
                             SitePref(siteName: "BBCSport", numPosts: 1),
                             SitePref(siteName: "Bloomberg", numPosts: 3),
                             SitePref(siteName: "BusinessInsider", numPosts: 1),
                             SitePref(siteName: "CNN", numPosts: 1),
                             SitePref(siteName: "EntertainmentWeekly", numPosts: 1),
                             SitePref(siteName: "Etsy", numPosts: 1),
                             SitePref(siteName: "HackerNews", numPosts: 1),
                             SitePref(siteName: "MTV", numPosts: 1),
                             SitePref(siteName: "NationalGeographic", numPosts: 1),
                             SitePref(siteName: "Newsweek", numPosts: 1),
                             SitePref(siteName: "NYMag", numPosts: 1),
                             SitePref(siteName: "NYTimes", numPosts: 1),
                             SitePref(siteName: "Reuters", numPosts: 1),
                             SitePref(siteName: "Spotify", numPosts: 1),
                             SitePref(siteName: "StackOverflow", numPosts: 1),
                             SitePref(siteName: "Time", numPosts: 1),
                             SitePref(siteName: "USAToday", numPosts: 1),
                             SitePref(siteName: "WashPost", numPosts: 1),
                             SitePref(siteName: "WSJ", numPosts: 1)]]
        // save them for the new user
        updateUserSitePrefs(newPrefs: newSitePrefs)
    }

    
}
