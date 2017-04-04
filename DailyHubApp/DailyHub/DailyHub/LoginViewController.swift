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
    
    var count = 0
    var loginButton: FBSDKLoginButton = {
        var lb = FBSDKLoginButton()
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.29, green: 0.29, blue:0.29, alpha: 1.0)
        
        // create the facebook login button
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate!
        
        delegate.switchToMainViewControllers()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


