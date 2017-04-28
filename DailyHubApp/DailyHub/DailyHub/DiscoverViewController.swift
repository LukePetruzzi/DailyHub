//
//  DiscoverViewController.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/27/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage



class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var masterData: String = ""
    
    var tableView: UITableView?
    
    var loadingOverlay: UIView!
    
    var refreshControl: UIRefreshControl!
    
    var masterContent = [String:[ContentInfo]]()
    
    //    var userSitePrefs = [SitePref(siteName: "500px", numPosts: 3),
    //                         SitePref(siteName: "AP", numPosts: 2),
    //                        SitePref(siteName: "BBCNews", numPosts: 5),
    //                        SitePref(siteName: "BBCSport", numPosts: 1),
    //                        SitePref(siteName: "Bloomberg", numPosts: 3),
    //                        SitePref(siteName: "BusinessInsider", numPosts: 1),
    //                        SitePref(siteName: "Buzzfeed", numPosts: 1),
    //                        SitePref(siteName: "CNN", numPosts: 1),
    //                        SitePref(siteName: "Deviant", numPosts: 1),
    //                        SitePref(siteName: "EntertainmentWeekly", numPosts: 1),
    //                        SitePref(siteName: "ESPN", numPosts: 1),
    //                        SitePref(siteName: "Etsy", numPosts: 1),
    //                        SitePref(siteName: "Giphy", numPosts: 1),
    //                        SitePref(siteName: "HackerNews", numPosts: 1),
    //                        SitePref(siteName: "IGN", numPosts: 1),
    //                        SitePref(siteName: "Imgur", numPosts: 1),
    //                        SitePref(siteName: "MTV", numPosts: 1),
    //                        SitePref(siteName: "NationalGeographic", numPosts: 1),
    //                        SitePref(siteName: "Newsweek", numPosts: 1),
    //                        SitePref(siteName: "NYMag", numPosts: 1),
    //                        SitePref(siteName: "NYTimes", numPosts: 1),
    //                        SitePref(siteName: "Reuters", numPosts: 1),
    //                        SitePref(siteName: "Soundcloud", numPosts: 1),
    //                        SitePref(siteName: "Spotify", numPosts: 1),
    //                        SitePref(siteName: "StackOverflow", numPosts: 1),
    //                        SitePref(siteName: "Techcrunch", numPosts: 1),
    //                        SitePref(siteName: "Time", numPosts: 1),
    //                        SitePref(siteName: "USAToday", numPosts: 1),
    //                        SitePref(siteName: "Vimeo", numPosts: 1),
    //                        SitePref(siteName: "WashPost", numPosts: 1),
    //                        SitePref(siteName: "WSJ", numPosts: 1),
    //                        SitePref(siteName: "YouTube", numPosts: 1)]
    var userSitePrefs:[SitePref] = [SitePref]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange,
                                                                        NSFontAttributeName: UIFont(name: "Avenir", size: 24)!]
        navigationController?.navigationBar.topItem?.title = "dh"
        
        
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.tableView = UITableView(frame: frame)
        let rankingsButton = UIBarButtonItem(image: UIImage(named: "ranking-3"), style: .plain, target: self, action: #selector(rankingButtonTappedTapped))
        rankingsButton.tintColor = UIColor.orange
        navigationItem.setRightBarButton(rankingsButton, animated: true)
        let helpButton = UIBarButtonItem(image: UIImage(named: "help"), style: .plain, target: self, action: #selector(helpButtonTappedTapped))
        helpButton.tintColor = UIColor.orange
        navigationItem.setLeftBarButton(helpButton, animated: true)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(FeedTableTitleCell.self, forCellReuseIdentifier: "FeedTableTitleCell")
        tableView?.register(FeedTableContentCell.self, forCellReuseIdentifier: "FeedTableContentCell")
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Release to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTable), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl)
        
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 500
        
        self.view.addSubview(tableView!)
        
        // loading overlay
        loadingOverlay = UIView(frame: UIScreen.main.bounds)
        loadingOverlay.backgroundColor = UIColor.white
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .gray
        indicator.frame = loadingOverlay.frame
        indicator.startAnimating()
        loadingOverlay.addSubview(indicator)
        
        // CREATING THE CONSTRAINTS RIGHT HERE IN OUR VIEWDIDLOAD MAY BE CAUSING THE CRASHES?
        //        let views: [String: UIView] = ["t": tableView!]
        //        var constraints: [NSLayoutConstraint] = []
        //
        //        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        //        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[t]|", options: [], metrics: nil, views: views)
        //        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[t]|", options: [], metrics: nil, views: views)
        //
        //        NSLayoutConstraint.activate(constraints)
        
        // add loading view and refresh the table when it loads
        // add on the loading overlay
        view.addSubview(loadingOverlay)
        // refresh the table
        self.refreshTable()
    }
    
    func completion() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTable() {
        
        //        let waitGroup = DispatchGroup()
        //        waitGroup.enter()
        //        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, relationship_status"]).start(completionHandler: {(connection, result, error) -> Void in
        //            if ((error) != nil)
        //            {
        //                print("Error: \(error)")
        //            }
        //            else{
        //                let res = result as! [String:AnyObject]
        //                userId = res["id"] as! String?
        //                userName = res["name"] as! String?
        //            }
        //
        //            // leave dispatch group when finished
        //            waitGroup.leave()
        //        })
        //        waitGroup.notify(queue: .main) {
        //            // set name and ID
        //            if (userId != nil) {
        //                let url =  URL(string: "http://graph.facebook.com/\(userId!)/picture?type=large")
        //                self.profileImageView.sd_setImage(with: url)
        //            }
        //            if (userName != nil) {
        //                self.profileNameLabel.text = userName!
        //            }
        //        }
        
        userSitePrefs = (CognitoUserManager.sharedInstance.retrieveUserSitePrefs(feedNumber: 0)?[1])!
        if userSitePrefs.count > 0
        {
            Database.getDatabaseInfo(completionHandler: {(data, error) in
                if let d = data {
                    
                    let json = d.data(using: .utf8)
                    
                    do {
                        let content = try JSONSerialization.jsonObject(with: json!, options: []) as! [String: NSArray]
                        for item in self.userSitePrefs {
                            // gets the content for the number rank needed
                            
                            var currentResults: [ContentInfo] = []
                            for i in 0..<item.numPosts {
                                
                                
                                let currentSiteContentDict = content[item.siteName]?[i] as AnyObject
                                let title = currentSiteContentDict["title"] as? String
                                let author = currentSiteContentDict["author"] as? String
                                let url = currentSiteContentDict["url"] as? String
                                let thumbnail = currentSiteContentDict["thumbnail"] as? String
                                let description = currentSiteContentDict["description"] as? String
                                let siteInfo = ContentInfo(title: title?.trimmingCharacters(in: .whitespacesAndNewlines),
                                                           author: author?.trimmingCharacters(in: .whitespacesAndNewlines),
                                                           url: url?.trimmingCharacters(in: .whitespacesAndNewlines),
                                                           thumbnail: thumbnail?.trimmingCharacters(in: .whitespacesAndNewlines),
                                                           description: description?.trimmingCharacters(in: .whitespacesAndNewlines))
                                currentResults.append(siteInfo)
                                // add the site info to the array of content
                                
                            }
                            self.masterContent[item.siteName] = currentResults
                        }
                    }
                    catch {
                        print("Error deserializing JSON: \(error)")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                        self.loadingOverlay.removeFromSuperview()
                    }
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }
    
    func rankingButtonTappedTapped() {
        let pvc = PreferencesViewController()
        self.tabBarController?.present(pvc, animated: true, completion: nil)
    }
    
    func helpButtonTappedTapped() {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userSitePrefs.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSitePrefs[section].numPosts
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableTitleCell") as! FeedTableTitleCell
        let image = userSitePrefs[section].siteName
        cell.logoImageView.image = UIImage(named: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableContentCell", for: indexPath) as! FeedTableContentCell
        let sect = userSitePrefs[indexPath.section].siteName
        
        if let title = masterContent[sect]?[indexPath.row].title {
            cell.titleLabel?.text = title
        }
        else{
            cell.titleLabel.text = ""
        }
        
        if let author = masterContent[sect]?[indexPath.row].author {
            cell.authorLabel?.text = author
        }
        else{
            cell.authorLabel.text = ""
        }
        
        if let desc = masterContent[sect]?[indexPath.row].description {
            cell.descLabel?.text = desc
        }
        else{
            cell.descLabel.text = ""
        }
        
        if let thumbnail = masterContent[sect]?[indexPath.row].thumbnail {
            
            cell.updateImgViewHeightConstraint(constant: 300 - FeedTableContentCell.Metrics.ABOVE_OR_BELOW)
            
            let url = URL(string: thumbnail)
            //cell.imgView?.frame = CGRect(x: CGFloat(5), y: 5+currHeight, width: UIScreen.main.bounds.width - 10, height: Metrics.maxImageHeight)
            cell.imgView?.sd_setImage(with: url)
            
        }
        else{
            cell.updateImgViewHeightConstraint(constant: 0)
            cell.imgView.image = nil
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get the section
        let sect = userSitePrefs[indexPath.section].siteName
        let urlString = masterContent[sect]?[indexPath.row].url
        
        // create a new webviewController
        let webViewController = CustomWebView()
        webViewController.urlStringToLoad = urlString!
        webViewController.logoToShow = sect
        webViewController.masterContent = masterContent
        webViewController.userSitePrefs = userSitePrefs
        webViewController.currSite = indexPath.section
        webViewController.currPostForSite = indexPath.row
        
        self.tabBarController?.present(webViewController, animated: true, completion: nil)
    }    
}
