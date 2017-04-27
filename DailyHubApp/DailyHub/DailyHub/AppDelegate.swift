//
//  AppDelegate.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 3/24/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit

import AWSCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var credentialsProvider: AWSCognitoCredentialsProvider?
    var configuration: AWSServiceConfiguration?
    
    var loginViewController: LoginViewController?
    
    var feedViewController: FeedViewController?
    var feedNavController: UINavigationController?
    
    var discoverViewController: UIViewController?
    var discoverNavController: UINavigationController?
    
    var profileViewController: ProfileViewController?
    var profileNavController: UINavigationController?
        
    var navigationController: UINavigationController?
    
    var tabController: UITabBarController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // connect facebook sdk
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // setup tab controller
        tabController = UITabBarController()

        // setup views
        feedViewController = FeedViewController()
        discoverViewController = UIViewController()
        profileViewController = ProfileViewController()
        loginViewController = LoginViewController()
        
        // setup navigation controllers
        feedNavController = UINavigationController(rootViewController: feedViewController!)
        discoverNavController = UINavigationController(rootViewController: discoverViewController!)
        profileNavController = UINavigationController(rootViewController: profileViewController!)
        
        // array of our view controllers for the tab controller.
        tabController?.viewControllers = [feedNavController!, discoverNavController!, profileNavController!]
        feedViewController?.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "feed"), tag: 0)
        discoverViewController?.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "explore"), tag: 1)
        profileViewController?.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile"), tag: 2)
        
        
        
        

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        // go to login screen if not logged in
        if (FBSDKAccessToken.current() != nil){
            // setup aws credentials
            self.initializeAuthorizedCognito()
            // go to the main view controller
            self.switchToMainViewControllers()
        }
        else {
            self.switchToLoginViewController()
        }
        
        return true
    }
    
    func initializeAuthorizedCognito()
    {
        // get authorized AWS credentials
        self.credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USWest2, identityPoolId: "us-west-2:d5f1d3e5-446b-4726-96cc-4faca9cd8ecb", identityProviderManager: FacebookCognitoIdentityProvider(tokens: FBSDKAccessToken.current().tokenString))
        self.configuration = AWSServiceConfiguration(region: AWSRegionType.USWest2 , credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // Retrieve your Amazon Cognito ID
        let waitGroup = DispatchGroup()
        waitGroup.enter()
        credentialsProvider?.getIdentityId().continueWith(block: { (task) -> AnyObject? in
            if (task.error != nil) {
                print("ERROR GETTING ID: " + task.error!.localizedDescription)
            }
            else {
                // the task result will contain the identity id
                let cognitoId = task.result!
                print("Cognito id: \(cognitoId)")
                
            }
            waitGroup.leave()
            waitGroup.notify(queue: .main){
                if (task.error  == nil){
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
                    
                    print("ORIGINAL SITEPREFS: \(newSitePrefs)")
                    // perform first time setup IF its a new user
                    CognitoUserManager.sharedInstance.convertSitePrefsToJSONString(newPrefs: newSitePrefs)
                }
            }
            
            return task;
        })
        
        
        
    }
    
    func logoutCurrentUser()
    {
        // clear the credentials
        self.credentialsProvider?.clearCredentials()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
    }
    
    func switchToMainViewControllers()
    {
        // add the tab controller to the navcontroller
        self.window?.rootViewController = self.tabController
    }
    
    func switchToLoginViewController()
    {
        self.window?.rootViewController = self.loginViewController
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DailyHub")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

