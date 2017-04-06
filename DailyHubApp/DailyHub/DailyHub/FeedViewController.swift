//
//  FeedViewController
//  DailyHub
//
//  Created by Luke Petruzzi on 3/24/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

struct SitePref {
    var siteName:String
    var numPosts:Int
}


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var masterData: JSON?
    
    var tableView: UITableView?
    
    var refreshControl: UIRefreshControl!

    var userSitePrefs = [SitePref(siteName: "500px", numPosts: 1),
                         SitePref(siteName: "AssociatedPress", numPosts: 1),
                        SitePref(siteName: "BBCNews", numPosts: 1),
                        SitePref(siteName: "BBCSport", numPosts: 1),
                        SitePref(siteName: "Bloomberg", numPosts: 1),
                        SitePref(siteName: "BusinessInsider", numPosts: 1),
                        SitePref(siteName: "Buzzfeed", numPosts: 1),
                        SitePref(siteName: "CNN", numPosts: 1),
                        SitePref(siteName: "DeviantArt", numPosts: 1),
                        SitePref(siteName: "EntertainmentWeekly", numPosts: 1),
                        SitePref(siteName: "ESPN", numPosts: 1),
                        SitePref(siteName: "Etsy", numPosts: 1),
                        SitePref(siteName: "Giphy", numPosts: 1),
                        SitePref(siteName: "HackerNews", numPosts: 1),
                        SitePref(siteName: "IGN", numPosts: 1),
                        SitePref(siteName: "Imgur", numPosts: 1),
                        SitePref(siteName: "MTV", numPosts: 1),
                        SitePref(siteName: "NatGeo", numPosts: 1),
                        SitePref(siteName: "Newsweek", numPosts: 1),
                        SitePref(siteName: "NYMag", numPosts: 1),
                        SitePref(siteName: "Reuters", numPosts: 1),
                        SitePref(siteName: "Soundcloud", numPosts: 1),
                        SitePref(siteName: "Spotify", numPosts: 1),
                        SitePref(siteName: "StackOverflow", numPosts: 1),
                        SitePref(siteName: "Techcrunch", numPosts: 1),
                        SitePref(siteName: "Time", numPosts: 1),
                        SitePref(siteName: "USAToday", numPosts: 1),
                        SitePref(siteName: "Vimeo", numPosts: 1),
                        SitePref(siteName: "WashingtonPost", numPosts: 1),
                        SitePref(siteName: "WSJ", numPosts: 1),
                        SitePref(siteName: "Youtube", numPosts: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.backgroundColor = UIColor(red:0.29, green: 0.29, blue:0.29, alpha: 1.0)
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.tableView = UITableView(frame: frame)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(FeedTableTitleCell.self, forCellReuseIdentifier: "FeedTableTitleCell")
        tableView?.register(FeedTableContentCell.self, forCellReuseIdentifier: "FeedTableContentCell")
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Release to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl)
        
        self.view.addSubview(tableView!)
        
        let views: [String: UIView] = ["t": tableView!]
        var constraints: [NSLayoutConstraint] = []
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[t]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[t]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Database.getDatabaseInfo(completionHandler: {(data, error) in
            if let d = data {
                self.masterData = JSON.init(parseJSON: d)
                self.tableView?.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTable() {
        self.tableView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSitePrefs[section].numPosts
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userSitePrefs.count;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableTitleCell") as! FeedTableTitleCell
        _ = masterData?["data"].array
        let image = userSitePrefs[section].siteName + ".png"
        cell.logoImageView.image = UIImage(named: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

