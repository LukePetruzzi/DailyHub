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
    
    var profileImageView: UIImageView = UIImageView()
    var profileNameLabel: UILabel = UILabel()
    var logoutButton: UIButton = UIButton()
    
    let PADDING:CGFloat = 6
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.29, green: 0.29, blue:0.29, alpha: 1.0)
        
        // add header
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange,
                                                                        NSFontAttributeName: UIFont(name: "Avenir", size: 24)!]
        navigationController?.navigationBar.topItem?.title = "dh"
        
        
        
        // label with name
        profileNameLabel.font = UIFont(name: "Avenir-Black", size: 16)
        
        // logout button
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        
        // add all the subviews
        self.view.addSubview(logoutButton)
        self.view.addSubview(profileImageView)
        self.view.addSubview(profileNameLabel)
        
        // create all constraints
        // get rid of constraints I DIDN'T FRIGGIN MAKE
        self.view.translatesAutoresizingMaskIntoConstraints = false
        for sub in self.view.subviews{
            sub.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // create constraints for the content view itself
        //self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        let navBarHeight = navigationController!.navigationBar.bounds.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let centerX = self.view.center.x
        
        print("HEIHGT: \(navBarHeight)")
        
        // constraints for the imageview
        self.view.addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: navBarHeight + statusBarHeight + PADDING))
        self.view.addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.bounds.width / 2))
        self.view.addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.bounds.width / 2))
        self.view.addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: centerX))

        // name label
        self.view.addConstraint(NSLayoutConstraint(item: profileNameLabel, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: profileImageView, attribute: .bottom, multiplier: 1, constant: PADDING))
        self.view.addConstraint(NSLayoutConstraint(item: profileNameLabel, attribute: .centerX, relatedBy: .equal, toItem: profileImageView, attribute: .centerX, multiplier: 1, constant: 0))
        
        // logout button
        self.view.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: profileNameLabel, attribute: .bottom, multiplier: 1, constant: PADDING))
        self.view.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: .centerX, relatedBy: NSLayoutRelation.equal, toItem: profileNameLabel, attribute: .centerX, multiplier: 1, constant: 0))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // load the data for image and name
        loadFacebookData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFacebookData()
    {
        var userId:String? = nil
        var userName:String? = nil
        
        // wait to load the image and name
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
                userName = res["name"] as! String?
            }
            
            // leave dispatch group when finished
            waitGroup.leave()
        })
        waitGroup.notify(queue: .main) {
            // set name and ID
            if (userId != nil) {
                let url =  URL(string: "http://graph.facebook.com/\(userId!)/picture?type=large")
                self.profileImageView.sd_setImage(with: url)
            }
            if (userName != nil) {
                self.profileNameLabel.text = userName!
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        

        // arrange all the frames
        //profileImageView.frame = CGRect(x: self.view.center.x - self.view.bounds.width / 4, y: self.view.bounds.width / 4, width: self.view.bounds.width / 2, height: self.view.bounds.width / 2)
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        
//        logoutButton = UIButton(frame: CGRect(x: 0, y: 200 , width: self.view.bounds.width, height: 50))

    }
    
    internal func logout(button: UIButton!)
    {
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate!
        
        // authorize the user and open the app's feed view
        delegate.logoutCurrentUser()
        delegate.switchToLoginViewController()
    }
}

