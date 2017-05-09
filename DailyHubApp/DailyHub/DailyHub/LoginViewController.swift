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
    
    var logoImageView: UIImageView = {
        var lb = UIImageView()
        return lb
    }()
    
    var loginButton: FBSDKLoginButton = {
        var lb = FBSDKLoginButton()
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:1, green: 1, blue:1, alpha: 1.0)
        
        logoImageView.image = #imageLiteral(resourceName: "logo")
        logoImageView.center = self.view.center
        logoImageView.contentMode = .scaleAspectFit
        
        
        // create the facebook login button
        loginButton.delegate = self
        loginButton.loginBehavior = .web
        
        
        self.view.addSubview(logoImageView)
        self.view.addSubview(loginButton)
        
        // create all constraints
        // get rid of constraints I DIDN'T FRIGGIN MAKE
        self.view.translatesAutoresizingMaskIntoConstraints = false
        for sub in self.view.subviews{
            sub.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let centerY = self.view.center.y
        
        
        self.view.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.bounds.height / 4))
        self.view.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.bounds.width / 2))
        self.view.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.bounds.width / 2))
        self.view.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
//        let ass = NSLayoutConstraint(item: logoImageView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
//        ass.priority = 1
//        self.view.addConstraint(ass)
        
        self.view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: logoImageView, attribute: .bottom, multiplier: 1, constant: self.view.bounds.height / 4))
        self.view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))

        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (!result.isCancelled && FBSDKAccessToken.current() != nil)
        {
            let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate!
        
            // authorize the user and open the app's feed view
            let waitGroup = DispatchGroup()
            waitGroup.enter()
            
            loginButton.isHidden = true

            
            CognitoUserManager.sharedInstance.initializeAuthorizedCognito(fbAccessTokenString: FBSDKAccessToken.current().tokenString, completion: {(err) -> Void in

                if err != nil {
                    print("ERROR LOGGING IN COGNITO: \(err!.localizedDescription)")
                    loginButton.isHidden = false
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


