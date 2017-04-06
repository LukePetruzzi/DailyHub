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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var masterData: JSON?
    
    var tableView: UITableView?
    
    var refreshControl: UIRefreshControl!

    var sites = ["500px", "AssociatedPress", "BBCNews", "BBCSport", "Bloomberg", "BusinessInsider", "CNN", "DeviantArt", "EntertainmentWeekly", "Etsy", "Giphy", "HackerNews", "MTV", "NatGeo", "Newsweek", "NYMag", "Reuters", "Spotify", "StackOverflow", "Techcrunch", "Time", "USAToday", "Vimeo", "WashingtonPost", "WSJ"]
    
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
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableTitleCell", for: indexPath) as! FeedTableTitleCell
        _ = masterData?["data"].array
        let image = sites[indexPath.row] + ".png"
        cell.logoImageView.image = UIImage(named: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}

