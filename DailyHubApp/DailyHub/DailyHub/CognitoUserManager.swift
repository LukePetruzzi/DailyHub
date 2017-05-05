//
//  CognitoUserController.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/3/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import AWSCognito
import AWSCore
import FBSDKCoreKit


class CognitoUserManager
{
    // Can't init, is singleton
    private init() { }
    static let sharedInstance: CognitoUserManager = CognitoUserManager()
    
    // the sync client used to update the user data to the Cognito cloud
    var syncClient: AWSCognito?
    
    var credentialsProvider: AWSCognitoCredentialsProvider?
    var configuration: AWSServiceConfiguration?
    
    func updateSyncClient(completion: @escaping ((_ error:NSError?) -> Void)){
        
        
        print("UPDATED THE SYNC CLIENT")
        if syncClient == nil {
            syncClient = AWSCognito.default()
        }
        
        let waitGroup = DispatchGroup()
        waitGroup.enter()
        syncClient?.refreshDatasetMetadata().continueWith(block: { (task) -> AnyObject? in

            if task.error != nil {
                print("ERROR WHEN GETTING DATASET METADATA: \(task.error!.localizedDescription)")
            }

            for set in self.syncClient!.listDatasets(){
                print("DATASET: ", set.name)
            }
            
            waitGroup.leave()
            waitGroup.notify(queue: .main){
                if task.error != nil{
                    completion(task.error! as NSError)
                }
                else{
                    completion(nil)
                }
            }
            return task
        })
    
    }

    
    

    
    func retrieveUserSitePrefs(feedNumber: Int) -> [Array<SitePref>]? {
        let dataset = self.syncClient!.openOrCreateDataset("userSitePrefs")

        
        
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
            
            let dataset = self.syncClient!.openOrCreateDataset("userSitePrefs")
            
            // set the value to be the double array of in feed or not in feed prefs
            // key is 0. so they can have many different feeds if they want
            dataset.setString(jsonString, forKey: "0")
            dataset.synchronize()
        }
        else{
            print("ERROR! COULDNT CONVERT SITE PREFS TO JSON STRING")
        }
    }
    
    func checkForFirstTimeUser(completion: @escaping (_ isFirstTimeUser: Bool) -> Void){
        
        var overallAnswer = true
        
        let waitGroup = DispatchGroup()
        
            // return if its been set up before
            for set in self.syncClient!.listDatasets() {
                waitGroup.enter()
                
                print("SET: \(set)")
                print("SET NAME: \(set.name!)")
                
                if (set.name! == "hasSetUp")
                {
                    overallAnswer = false
                }
                waitGroup.leave()
            }
        
        waitGroup.notify(queue: .main){
            completion(overallAnswer)
        }
    }
    
    func firstTimeUserCheckAndSetup(completion: @escaping (_ error: NSError?) -> Void)
    {
        
        // Retrieve your Amazon Cognito ID
        checkForFirstTimeUser(completion: {(isFirstTimeUser) -> Void in
            
            print("THIS IS THE VALUE OF isFirstTimeUser BOOL: \(isFirstTimeUser)")
            
            if (!isFirstTimeUser){
                // synchronize the existing user site preferences
                let dataset = self.syncClient!.openOrCreateDataset("userSitePrefs")
                dataset.synchronize().continueWith(block: { (task) -> AnyObject? in
                    
                    if task.error != nil {
                        print("ERROR WHEN RETRIEVING EXISTING SITE PREFS: \(task.error!.localizedDescription)")
                        completion(task.error! as NSError)
                    } else {
                        // Task succeeded. The data was saved in the sync store.
                        print("SUCCESSFULLY RETRIEVED EXISTING USER SITE PREFS")
                        print("THESE ARE THEM: \(dataset.string(forKey: String(0)))")
                        completion(nil)
                    }

                    
                    return task
                })
                
                // leave before overwriting preferences below
                return
            }
            
            // set up for the first time
            let dataset = self.syncClient!.openOrCreateDataset("hasSetUp")
            // doesn't matter whats stored in here
            dataset.setString("Anything", forKey: "AnythingElse")
            dataset.synchronize()
            
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
            
            print("CREATING NEW USER PREFS FOR FIRST TIME USER!")
            
            // update user site prefs... but wait to do it instead of using async function above
            if let jsonString = self.convertSitePrefsToJSONString(newPrefs: newSitePrefs)
            {
                
                let dataset = self.syncClient!.openOrCreateDataset("userSitePrefs")
                
                // set the value to be the double array of in feed or not in feed prefs
                // key is 0. so they can have many different feeds if they want
                dataset.setString(jsonString, forKey: "0")
                dataset.synchronize().continueWith(block: { (task) -> AnyObject? in
                    
                    if task.error != nil {
                        print("ERROR WHEN UPDATING NEW SITE PREFS: \(task.error!.localizedDescription)")
                        completion(task.error! as NSError)
                    } else {
                        // Task succeeded. The data was saved in the sync store.
                        print("SUCCESSFULLY UPDATED USER NEW SITE PREFS")
                        completion(nil)
                    }
                    
                    return task
                })
            }
            else{
                print("ERROR! COULDNT CONVERT NEW SITE PREFS TO JSONSTRING")
            }
        })
    }
    
    // DO THIS DIFFERENTLY! ADD THE DATE ADDED BACK TO THE FAVORITED POST STRUCT. THEN, WHEN ADDING TO FAVORITES, USE
    // A HASH OF THE CONTENT INFO (CANT USE THE FAVORITED POST JSON CUZ TIME WILL BE DIFFERENT) AS THE KEY. IF THE DATABASE CONTAINS THE KEY, ADD IT, ELSE, DONT
    func addPostToFavorites(siteName: String, contentInfo: ContentInfo)
    {
        
        let dataset = self.syncClient!.openOrCreateDataset("favorites")
        
        // get current date and set all parameters to a favoritedPost struct
        let currentDateTime = Database.getFormattedESTDateAndTime()
        print("TIME: \(currentDateTime)")
        // add all contentinfo to the favoritedPost
        print("CONTENT INFO: \(contentInfo)")
        let favoritedPost = FavoritedPost(siteName: siteName, title: contentInfo.title, author: contentInfo.author, url: contentInfo.url, thumbnail: contentInfo.thumbnail, description: contentInfo.description)
        // convert to json string
        if let json = favoritedPost.toJSON() {
            print("JSON OF INFO: \(json)")
            
            // save the favorite, keyed as the time it was saved
            dataset.setString(json, forKey: currentDateTime)
            
            dataset.synchronize().continueWith(block: { (task) -> AnyObject? in

                if task.isCancelled {
                    print("TASK CANCELLED WHEN SYNCRONIZING FAVORITE TO DATABASE")
                } else if task.error != nil {
                    print("ERROR WHEN ADDING NEW SITE PREFS: \(task.error!.localizedDescription)")
                } else {
                    // Task succeeded. The data was saved in the sync store.
                }
                return task
            })
        }
        else{
            print("ERROR, POUNDED JSON OF CONTENT INFO's SAND")
        }
    }
    
    // *********************************************** LOGIN AND LOGOUT *******************************************************************************************
    
    // initialize the cognito by getting the identity id from the facebook access token
    func initializeAuthorizedCognito(fbAccessTokenString: String, completion: @escaping ((_ error:NSError?) -> Void))
    {
        // get authorized AWS credentials
        self.credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USWest2, identityPoolId: "us-west-2:d5f1d3e5-446b-4726-96cc-4faca9cd8ecb", identityProviderManager: FacebookCognitoIdentityProvider(tokens: fbAccessTokenString))
        self.configuration = AWSServiceConfiguration(region: AWSRegionType.USWest2 , credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        //        if credentialsProvider?.identityId != nil {
        //            print("Cognito id: \(credentialsProvider!.identityId)")
        //            // perform first time setup IF its a new user
        //            CognitoUserManager.sharedInstance.updateSyncClient()
        //            CognitoUserManager.sharedInstance.firstTimeUserCheckAndSetup()
        //            completion(nil)
        //        }
        //        else {
        //            print("THE CREDENTNTIALS MANAGER DIDN'T SET UP ")
        //        }
        
        // Ensures I'm waiting until the credentials provider is set up
        let waitGroup = DispatchGroup()
        
        credentialsProvider?.getIdentityId().continueWith(block: { (task) -> AnyObject? in
            
            waitGroup.enter()
            
            if (task.error != nil) {
                waitGroup.leave()
            }
            else {
                // the task result will contain the identity id
                let cognitoId = task.result!
                print("Cognito id: \(cognitoId)")
                
                waitGroup.leave()
            }
            
            waitGroup.notify(queue: .main)
            {
                if (task.error == nil) {
                    // perform first time setup IF its a new user
                    CognitoUserManager.sharedInstance.updateSyncClient(completion: {(err) -> Void in
                        if (err != nil){
                            print("ERROR SETTING UP THE COGNITO MANAGER SYNC CLIENT")
                            completion(err)
                        }
                        else {
                            CognitoUserManager.sharedInstance.firstTimeUserCheckAndSetup(completion: {(e) -> Void in
                                if (e != nil){
                                    completion(e)
                                }
                                else{
                                    completion(nil)
                                }
                            })
                            
                        }
                    })
                }
            }
            
            return task;
        })
    }

    
    func logoutCurrentUser()
    {

        
        // clear the credentials
        credentialsProvider?.clearCredentials()
        credentialsProvider?.clearKeychain()
        credentialsProvider?.invalidateCachedTemporaryCredentials()
        
        assert(credentialsProvider?.identityId == nil)
        
        // this just doesn't work because whenever I try to sync the preferences again after getting them I end up saving an empty set of them
        // clear all dataset information from local storage
        var setNames = [String]()
        for set in syncClient!.listDatasets(){
            setNames.append(set.name!)
        }
        for name in setNames{
            let dataset = self.syncClient!.openOrCreateDataset(name)
            dataset.clear()
            print("BEFORE LOGOUT, CLEARED DATASET: \(name)")
        }
        
        if syncClient != nil {
            syncClient!.wipe()
            syncClient = nil
        }
        //syncClient = nil
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
    }
    
    // ************************************* PRIVATE HELPER FUNCTIONS ********************************************************************************************
    
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
