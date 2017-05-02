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

    

    
    func retrieveUserSitePrefs(feedNumber: Int) -> [Array<SitePref>]? {
        let dataset = self.syncClient.openOrCreateDataset("userSitePrefs")
        
        // set the value to be the double array of in feed or not in feed prefs
        // key is 0. so they can have many different feeds if they want
        if let jsonString = dataset.string(forKey: String(feedNumber)){
        
            if let sitePrefs = convertJSONStringToSitePrefsArray(jsonString: jsonString)
            {
                return sitePrefs
            }
        }
        return nil
    }
    
    
    func updateUserSitePrefs(newPrefs: [Array<SitePref>])
    {
        if let jsonString = convertSitePrefsToJSONString(newPrefs: newPrefs)
        {
            
            let dataset = self.syncClient.openOrCreateDataset("userSitePrefs")
            
            // set the value to be the double array of in feed or not in feed prefs
            // key is 0. so they can have many different feeds if they want
            dataset.setString(jsonString, forKey: "0")
            
            dataset.synchronize().continueWith(block: { (task) -> AnyObject? in
                
                if task.isCancelled {
                    print("TASK CANCELLED WHEN ADDING NEW SITE PREFS")
                } else if task.error != nil {
                    print("ERROR WHEN ADDING NEW SITE PREFS: \(task.error?.localizedDescription)")
                } else {
                    // Task succeeded. The data was saved in the sync store.
                    print("ADDED: \(jsonString)")
                }
                return task
            })
        }
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
                            [SitePref(siteName: "500px", numPosts: 1),
                             SitePref(siteName: "AP", numPosts: 1),
                             SitePref(siteName: "BBCNews", numPosts: 1),
                             SitePref(siteName: "BBCSport", numPosts: 1),
                             SitePref(siteName: "Bloomberg", numPosts: 1),
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
    
    private func convertJSONStringToSitePrefsArray(jsonString: String) -> [Array<SitePref>]?
    {
        if let data = jsonString.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]                
                
                var feedArray = [SitePref]()
                var notFeedArray = [SitePref]()
                var output = [Array<SitePref>]()
                
                if let feed = json["inFeed"] as? Array<String> {
                    for stringDict in feed {
                        let site = try JSONSerialization.jsonObject(with: stringDict.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                        let pref = SitePref(siteName: site["siteName"] as! String, numPosts: site["numPosts"] as! Int)
                        feedArray.append(pref)
                    }
                }
                if let notFeed = json["notInFeed"] as? Array<String> {
                    for stringDict in notFeed {
                        let site = try JSONSerialization.jsonObject(with: stringDict.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                        let pref = SitePref(siteName: site["siteName"] as! String, numPosts: site["numPosts"] as! Int)
                        notFeedArray.append(pref)
                    }
                }
                
                // append the two pounders
                output.append(feedArray)
                output.append(notFeedArray)
                
                return output
            } catch {
                
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func convertSitePrefsToJSONString(newPrefs: [Array<SitePref>]) -> String? {
        
        
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
        
        // create a big ol' dict of the two arrays
        let dict:[String:[String]] = ["inFeed":inFeedArray, "notInFeed":notInFeedArray]
        
        // convert to json string
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return JSONString
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }


    
}
