//
//  SettingsViewController.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/6/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.29, green: 0.29, blue:0.29, alpha: 1.0)
        
        // create all UI elements
        self.arrangeUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func arrangeUI()
    {
        let frame = CGRect(x: 0, y: 200, width: self.view.bounds.width, height: 50)
        self.logoutButton = UIButton(frame: frame)
        logoutButton?.contentVerticalAlignment = .bottom
        logoutButton?.contentHorizontalAlignment = .center
        
        logoutButton?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        logoutButton?.setTitle("Logout", for: .normal)
        logoutButton?.addTarget(self, action: #selector(logout), for: .touchUpInside)
        self.view.addSubview(logoutButton!)
    }
    
    internal func logout(button: UIButton!)
    {
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate!
        
        // authorize the user and open the app's feed view
        delegate.logoutCurrentUser()
        delegate.switchToLoginViewController()
    }
}

