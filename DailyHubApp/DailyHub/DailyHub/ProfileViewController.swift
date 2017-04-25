//
//  SettingsViewController.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/6/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    var profileImageView: UIImageView!
    var profileName: UILabel!
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
        // profile image view
        profileImageView = UIImageView(frame: CGRect(x: self.view.center.x - 25, y: 50, width: 50, height: 50))
        
        var userId:String? = nil
        
        let waitGroup = DispatchGroup()
        waitGroup.enter()
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, relationship_status"]).start(completionHandler: {(connection, result, error) -> Void in
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else{
                let res = result as! [String:AnyObject]
                userId = res["id"] as! String?
            }
            
            // leave dispatch group when finished
            waitGroup.leave()
        })
        
        waitGroup.notify(queue: .main) {
            if (userId != nil)
            {
                let url =  URL(string: "http://graph.facebook.com/\(userId)/picture?type=large")
                self.profileImageView.sd_setImage(with: url)
                self.profileImageView.backgroundColor = UIColor.red
                print("ASS: \(url?.absoluteString)")
            }
        }
        
        
        
        
        
        
        // logout button
        logoutButton = UIButton(frame: CGRect(x: 0, y: 200 , width: self.view.bounds.width, height: 50))
        logoutButton.contentVerticalAlignment = .bottom
        logoutButton.contentHorizontalAlignment = .center
        logoutButton.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        
        // add all the subviews
        self.view.addSubview(logoutButton)
        self.view.addSubview(profileImageView)
    }
    
    internal func logout(button: UIButton!)
    {
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate!
        
        // authorize the user and open the app's feed view
        delegate.logoutCurrentUser()
        delegate.switchToLoginViewController()
    }
}

