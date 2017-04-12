//
//  FeedViewController
//  DailyHub
//
//  Created by Luke Petruzzi on 3/24/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

struct SitePref {
    var siteName:String
    var numPosts:Int
}

struct ContentInfo {
    var title:String?
    var author:String?
    var url:String?
    var thumbnail:String?
    var description:String?
}

private struct Metrics {
    static let maxImageHeight:CGFloat = 300
    static let maxDescHeight:CGFloat = 100
}


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var masterData: String = ""
    
    var tableView: UITableView?
    
    var refreshControl: UIRefreshControl!
    
    var masterContent = [String:[ContentInfo]]()

    var userSitePrefs = [SitePref(siteName: "500px", numPosts: 1),
                         SitePref(siteName: "AP", numPosts: 1),
                        SitePref(siteName: "BBCNews", numPosts: 1),
                        SitePref(siteName: "BBCSport", numPosts: 1),
                        SitePref(siteName: "Bloomberg", numPosts: 1),
                        SitePref(siteName: "BusinessInsider", numPosts: 1),
                        SitePref(siteName: "Buzzfeed", numPosts: 1),
                        SitePref(siteName: "CNN", numPosts: 1),
                        SitePref(siteName: "Deviant", numPosts: 1),
                        SitePref(siteName: "EntertainmentWeekly", numPosts: 1),
                        SitePref(siteName: "ESPN", numPosts: 1),
                        SitePref(siteName: "Etsy", numPosts: 1),
                        SitePref(siteName: "Giphy", numPosts: 1),
                        SitePref(siteName: "HackerNews", numPosts: 1),
                        SitePref(siteName: "IGN", numPosts: 1),
                        SitePref(siteName: "Imgur", numPosts: 1),
                        SitePref(siteName: "MTV", numPosts: 1),
                        SitePref(siteName: "NationalGeographic", numPosts: 1),
                        SitePref(siteName: "Newsweek", numPosts: 1),
                        SitePref(siteName: "NYMag", numPosts: 1),
                        SitePref(siteName: "NYTimes", numPosts: 1),
                        SitePref(siteName: "Reuters", numPosts: 1),
                        SitePref(siteName: "Soundcloud", numPosts: 1),
                        SitePref(siteName: "Spotify", numPosts: 1),
                        SitePref(siteName: "StackOverflow", numPosts: 1),
                        SitePref(siteName: "Techcrunch", numPosts: 1),
                        SitePref(siteName: "Time", numPosts: 1),
                        SitePref(siteName: "USAToday", numPosts: 1),
                        SitePref(siteName: "Vimeo", numPosts: 1),
                        SitePref(siteName: "WashPost", numPosts: 1),
                        SitePref(siteName: "WSJ", numPosts: 1),
                        SitePref(siteName: "YouTube", numPosts: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.backgroundColor = UIColor(red:0.29, green: 0.29, blue:0.29, alpha: 1.0)
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.tableView = UITableView(frame: frame)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(FeedTableTitleCell.self, forCellReuseIdentifier: "FeedTableTitleCell")
        tableView?.register(FeedTableContentCell.self, forCellReuseIdentifier: "FeedTableContentCell")
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 500
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Release to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl)
        
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 500
        
        self.view.addSubview(tableView!)
        
        let views: [String: UIView] = ["t": tableView!]
        var constraints: [NSLayoutConstraint] = []
        
//        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[t]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[t]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // refresh the table with new things
        self.refreshTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTable() {
        Database.getDatabaseInfo(completionHandler: {(data, error) in
            if let d = data {
                
                let json = d.data(using: .utf8)
                
                do {
                    let content = try JSONSerialization.jsonObject(with: json!, options: []) as! [String: NSArray]
                    for item in self.userSitePrefs {
                        // gets the content for the number rank needed
                        let currentSiteContentDict = content[item.siteName]?[0] as AnyObject
                        let siteInfo = ContentInfo(title: currentSiteContentDict["title"] as? String,
                                                   author: currentSiteContentDict["author"] as? String,
                                                   url: currentSiteContentDict["url"] as? String,
                                                   thumbnail: currentSiteContentDict["thumbnail"] as? String,
                                                   description: currentSiteContentDict["description"] as? String)
                        // add the site info to the array of content
                        self.masterContent[item.siteName] = [siteInfo]
                    }
                }
                catch {
                    print("Error deserializing JSON: \(error)")
                }

                
                self.tableView?.reloadData()
            }
        })
        refreshControl.endRefreshing()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userSitePrefs.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSitePrefs[section].numPosts
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableTitleCell") as! FeedTableTitleCell
        let image = userSitePrefs[section].siteName + ".png"
        cell.logoImageView.image = UIImage(named: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableContentCell", for: indexPath) as! FeedTableContentCell
        let sect = userSitePrefs[indexPath.section].siteName
        var currHeight = 0
        
        if let title = masterContent[sect]?[0].title {
            cell.titleLabel?.frame = CGRect(x: 5, y: 5, width: Int(UIScreen.main.bounds.width - 10), height: 0)
            cell.titleLabel?.numberOfLines = 0
            cell.titleLabel?.text = title
            cell.titleLabel?.sizeToFit()
            currHeight += Int((cell.titleLabel?.frame.size.height)!)
        }
        
        if let author = masterContent[sect]?[0].author {
            cell.authorLabel?.frame = CGRect(x: 5, y: 5+currHeight, width: Int(UIScreen.main.bounds.width - 10), height: 15)
            cell.authorLabel?.text = author
            currHeight += 15
        }
        
        if let desc = masterContent[sect]?[0].description {
            cell.descLabel?.frame = CGRect(x: 5, y: 5+currHeight, width: Int(UIScreen.main.bounds.width - 10), height: 0)
            cell.descLabel?.numberOfLines = 0
            cell.descLabel?.text = desc
            cell.descLabel?.sizeToFit()
            if (cell.descLabel?.frame.size.height)! > Metrics.maxDescHeight {
                currHeight += Int(Metrics.maxDescHeight)
                cell.descLabel?.frame.size.height = Metrics.maxDescHeight
            }
            else {
                currHeight += Int((cell.descLabel?.frame.size.height)!)
            }
        }
        
        if let thumbnail = masterContent[sect]?[0].thumbnail {
            
            let url = URL(string: thumbnail)
            cell.imgView?.frame = CGRect(x: CGFloat(5), y: CGFloat(5+currHeight), width: UIScreen.main.bounds.width - 10, height: Metrics.maxImageHeight)
            cell.imgView?.sd_setImage(with: url, placeholderImage: UIImage(named: "dogpound.jpg"))
            
            
//            let url = NSURL(string: thumbnail)
//            let data = NSData(contentsOf: url as! URL)
//            if data != nil {
//                let thumbnailImage = UIImage(data: data as! Data)
//                var height:CGFloat = Metrics.maxImageHeight
//                
//                
//                if let thumbimage = thumbnailImage {
//                    if thumbimage.size.height < Metrics.maxImageHeight {
//                        height = thumbimage.size.height
//                    }
//                
//                    
//                    
//                    cell.imgView?.sd_setImage(with: url)
//                
//                }
//            }
        }
        
//        cell.authorLabel?.text = masterContent[sect]?[0].author

        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        var currHeight:CGFloat = 0
        let sect = userSitePrefs[indexPath.section].siteName

        
        if let _ = masterContent[sect]?[0].title {
            let titleLabel = UILabel(frame: CGRect(x: 5, y: 5, width: Int(UIScreen.main.bounds.width - 10), height: 0))
            titleLabel.numberOfLines = 0
            titleLabel.text = title
            titleLabel.sizeToFit()
            currHeight += titleLabel.frame.size.height
        }
        
        if let _ = masterContent[sect]?[0].author {
            currHeight += 15
        }
        
        if let descText = masterContent[sect]?[0].description {
            let descLabel = UILabel(frame: CGRect(x: 5, y: 0, width: Int(UIScreen.main.bounds.width - 10), height: 0))
            descLabel.numberOfLines = 0
            descLabel.text = descText
            descLabel.sizeToFit()
            if (descLabel.frame.size.height) > Metrics.maxDescHeight {
                currHeight += Metrics.maxDescHeight
            }
            else {
                currHeight += descLabel.frame.size.height
            }
        }
        
        if let _ = masterContent[sect]?[0].thumbnail {
            currHeight += Metrics.maxImageHeight
        }
        
        // For padding and the boys
        currHeight += 10
        return currHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("SHOULD BE OPENING:")
        
        // get the section
        let sect = userSitePrefs[indexPath.section].siteName
        let urlString = masterContent[sect]?[0].url
        
        // create a new webviewController
        let webViewController = WebViewC()
        webViewController.urlStringToLoad = urlString
        
//        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate!
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
