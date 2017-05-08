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
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var loginViewController: LoginViewController?
    
    var feedViewController: FeedViewController?
    var feedNavController: UINavigationController?
    
    var discoverViewController: DiscoverViewController?
    var discoverNavController: UINavigationController?
    
    var profileViewController: ProfileViewController?
    var profileNavController: UINavigationController?
        
    var navigationController: UINavigationController?
    
    var tabController: UITabBarController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        //launch Firebase
        FIRApp.configure()
        
        // connect facebook sdk
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // setup tab controller
        tabController = UITabBarController()

        // setup views
        feedViewController = FeedViewController()
        discoverViewController = DiscoverViewController()
        profileViewController = ProfileViewController()
        loginViewController = LoginViewController()
        
        // setup navigation controllers
        feedNavController = UINavigationController(rootViewController: feedViewController!)
        discoverNavController = UINavigationController(rootViewController: discoverViewController!)
        profileNavController = UINavigationController(rootViewController: profileViewController!)
        
        // array of our view controllers for the tab controller.
        tabController?.viewControllers = [feedNavController!, discoverNavController!, profileNavController!]
        let item1 = UITabBarItem(title: nil, image: UIImage(named: "feed"), tag: 0)
        item1.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        feedViewController?.tabBarItem = item1
        
        let item2 = UITabBarItem(title: nil, image: UIImage(named: "explore"), tag: 1)
        item2.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        discoverViewController?.tabBarItem = item2
        
        let item3 = UITabBarItem(title: nil, image: UIImage(named: "profile"), tag: 2)
        item3.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        profileViewController?.tabBarItem = item3
        
        tabController?.tabBar.tintColor = UIColor(red:1.00, green:0.40, blue:0.23, alpha:1.0)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        // this should our app launch screen or something like "Attepting to log you in"
        self.window?.rootViewController = self.loginViewController

        // go to login screen if not logged in
        let waitGroup = DispatchGroup()
        if (FBSDKAccessToken.current() != nil){
            // setup aws credentials
            waitGroup.enter()
            CognitoUserManager.sharedInstance.initializeAuthorizedCognito(fbAccessTokenString: FBSDKAccessToken.current().tokenString, completion: {(err) -> Void in
                if err != nil{
                    print("ERROR SETTING UP COGNITO LOGIN WHEN FBACCESS TOKEN NOT NIL : \(err!.localizedDescription)")
                }
                waitGroup.leave()
            })
            waitGroup.notify(queue: .main){
                // go to the main view controller
                self.switchToMainViewControllers()
            }
        }
        else {
            self.switchToLoginViewController()
        }
        
        return true
    }
    
    
    
    func switchToMainViewControllers()
    {
        // reinitialize the feed controller on login
//        feedViewController = FeedViewController()
//        feedNavController = UINavigationController(rootViewController: feedViewController!)
//
//        tabController?.viewControllers?[0] = feedNavController!
        
        
        // add the tab controller to the navcontroller
//        self.tabController?.selectedViewController = feedNavController
//        print("refreshing from appdelegate")
        
        // reinstantiate the view controllers that depend on feed stuff
        feedViewController = nil
        discoverViewController = nil
        feedViewController = FeedViewController()
        discoverViewController = DiscoverViewController()
        
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

