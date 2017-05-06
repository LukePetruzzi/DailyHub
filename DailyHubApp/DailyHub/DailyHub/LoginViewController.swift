//
//  LoginViewController.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/3/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AWSCognito


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var loginButton: FBSDKLoginButton = {
        var lb = FBSDKLoginButton()
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(red:0.29, green: 0.29, blue:0.29, alpha: 1.0)
        
        // create the facebook login button
        loginButton.center = self.view.center
        loginButton.delegate = self
        loginButton.loginBehavior = .web
        self.view.addSubview(loginButton)
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (!result.isCancelled && FBSDKAccessToken.current() != nil)
        {
            let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate!
        
            // authorize the user and open the app's feed view
            let waitGroup = DispatchGroup()
            waitGroup.enter()
            
            CognitoUserManager.sharedInstance.initializeAuthorizedCognito(fbAccessTokenString: FBSDKAccessToken.current().tokenString, completion: {(err) -> Void in

                if err != nil {
                    print("ERROR LOGGING IN COGNITO: \(err!.localizedDescription)")
                }
                waitGroup.leave()
            })
            
            waitGroup.notify(queue: .main) {
                print("SWITCHING TO MAIN VIEW CONTROLLERS NOW")
                delegate.switchToMainViewControllers()
            }
        }
        else {
            print("ERROR LOGGING IN: ")
            if (error != nil){
                print(error.localizedDescription)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        CognitoUserManager.sharedInstance.logoutCurrentUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


