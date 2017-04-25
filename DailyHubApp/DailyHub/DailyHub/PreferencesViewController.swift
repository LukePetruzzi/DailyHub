//
//  PreferencesViewController.swift
//  DailyHub
//
//  Created by Joe Salter on 4/19/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    public var sections = ["Displayed", "Not Displayed"]
    public var Array  = [[#imageLiteral(resourceName: "YouTube"), #imageLiteral(resourceName: "AP"), #imageLiteral(resourceName: "BBCNews"), #imageLiteral(resourceName: "BBCSport"), #imageLiteral(resourceName: "Bloomberg"), #imageLiteral(resourceName: "BusinessInsider"), #imageLiteral(resourceName: "Buzzfeed"), #imageLiteral(resourceName: "CNN"), #imageLiteral(resourceName: "Deviant"), #imageLiteral(resourceName: "EntertainmentWeekly"), #imageLiteral(resourceName: "ESPN"), #imageLiteral(resourceName: "Etsy"), #imageLiteral(resourceName: "Giphy"), #imageLiteral(resourceName: "HackerNews"), #imageLiteral(resourceName: "IGN"), #imageLiteral(resourceName: "Imgur"), #imageLiteral(resourceName: "MTV"), #imageLiteral(resourceName: "NationalGeographic"), #imageLiteral(resourceName: "Newsweek"), #imageLiteral(resourceName: "NYMag"),  #imageLiteral(resourceName: "NYTimes"), #imageLiteral(resourceName: "Reuters"), #imageLiteral(resourceName: "Soundcloud"),#imageLiteral(resourceName: "Spotify"), #imageLiteral(resourceName: "StackOverflow"), #imageLiteral(resourceName: "Techcrunch"), #imageLiteral(resourceName: "Time"), #imageLiteral(resourceName: "USAToday"), #imageLiteral(resourceName: "Vimeo"), #imageLiteral(resourceName: "WashPost"), #imageLiteral(resourceName: "WSJ")],[]]
    
    var userSitePrefs = [[SitePref(siteName: "500px", numPosts: 3),
                         SitePref(siteName: "AP", numPosts: 2),
                         SitePref(siteName: "BBCNews", numPosts: 5),
                         SitePref(siteName: "BBCSport", numPosts: 1),
                         SitePref(siteName: "Bloomberg", numPosts: 3),
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
                         SitePref(siteName: "YouTube", numPosts: 1)], []]

    
    private var tableView: UITableView!
    
    var headerView: UIView = UIView()
    var closeButton: UIButton = UIButton()
    var checkButton: UIButton = UIButton()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PreferencesCell.self, forCellReuseIdentifier: "PreferencesCell")
        tableView.setEditing(true, animated: true)
        tableView.isScrollEnabled = true
        
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
        headerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.9)
        
        checkButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        checkButton.setImage(UIImage(named: "check"), for: .normal)
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        headerView.addSubview(checkButton)
        
        closeButton.frame = CGRect(x: self.view.frame.size.width - 45, y: 0, width: 45, height: 45)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        headerView.addSubview(closeButton)
                    
        self.view.addSubview(tableView)
        self.view.addSubview(headerView)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
        tableView.frame = CGRect(x: 0, y: 45, width: self.view.frame.width, height: self.view.frame.height - 45)
    }
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkButtonTapped() {

    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if (sourceIndexPath != destinationIndexPath){
            
            let sourceItem = userSitePrefs[sourceIndexPath.section][sourceIndexPath.row]
            userSitePrefs[sourceIndexPath.section].remove(at: sourceIndexPath.row )
            userSitePrefs[destinationIndexPath.section].insert(sourceItem, at: destinationIndexPath.row)
            tableView.reloadData()
            
//            let sourceItem = Array[sourceIndexPath.section][sourceIndexPath.row]
//            Array[sourceIndexPath.section].remove(at: sourceIndexPath.row )
//            Array[destinationIndexPath.section].insert(sourceItem, at: destinationIndexPath.row)
//            tableView.reloadData()
//            print ("HET")
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(Array[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSitePrefs[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesCell", for: indexPath) as! PreferencesCell
        //cell.textLabel!.text = "\(Array[indexPath.section][indexPath.row])"
        let image = UIImage(named: userSitePrefs[indexPath.section][indexPath.row].siteName)
        let imageWidth = (image?.size.width)!
        let imageHeight = (image?.size.height)!
        
        let frame = tableView.rectForRow(at: indexPath)
        
        let widthRatio = 0.6 * frame.size.width / imageWidth
        let heightRatio = 0.8 * frame.size.height / imageHeight

        var newSize: CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: imageWidth * heightRatio, height: imageHeight * heightRatio)
        } else {
            newSize = CGSize(width: imageWidth * widthRatio, height: imageHeight * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        cell.logoImageView.frame = CGRect(x: 50, y: 8, width: newSize.width, height: 36)
        cell.logoImageView.image = image
        
        if (indexPath.section == 0) {
            
            cell.dropDownButton.setImage(UIImage(named: "down"), for: .normal)
            
            switch userSitePrefs[indexPath.section][indexPath.row].numPosts {
            case 1:
                cell.numPostsButton.setTitle("\u{2460}", for: .normal)
            case 2:
                cell.numPostsButton.setTitle("\u{2461}", for: .normal)
            case 3:
                cell.numPostsButton.setTitle("\u{2462}", for: .normal)
            case 4:
                cell.numPostsButton.setTitle("\u{2463}", for: .normal)
            case 5:
                cell.numPostsButton.setTitle("\u{2464}", for: .normal)
            case 6:
                cell.numPostsButton.setTitle("\u{2465}", for: .normal)
            case 7:
                cell.numPostsButton.setTitle("\u{2466}", for: .normal)
            case 8:
                cell.numPostsButton.setTitle("\u{2467}", for: .normal)
            case 9:
                cell.numPostsButton.setTitle("\u{2468}", for: .normal)
            case 10:
                cell.numPostsButton.setTitle("\u{2469}", for: .normal)
            default:
                break
            }
        }
        else {
            cell.dropDownButton.setImage(UIImage(named: "up"), for: .normal)
            cell.numPostsButton.setTitle("", for: .normal)
        }
        
//        let frame = tableView.rectForRow(at: indexPath)
        
//        let widthRatio = 0.6 * frame.size.width / ImageA.size.width
//        let heightRatio = 0.8 * frame.size.height / ImageA.size.height
//
//        var newSize: CGSize
//        if (widthRatio > heightRatio) {
//            newSize = CGSize(width: ImageA.size.width * heightRatio, height: ImageA.size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: ImageA.size.width * widthRatio, height: ImageA.size.height * widthRatio)
//        }
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//        
//        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        UIGraphicsGetCurrentContext()?.interpolationQuality = .high
//        ImageA.draw(in: rect)
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
//        UIGraphicsEndImageContext()
        
        
        
        
        
        
        // UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        // ImageA.draw(in: rect)
        // let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // UIGraphicsEndImageContext()
        //UIImage(data: #imageLiteral(resourceName: "YouTube"), scale: 13)
        //let scaledIconD = UIImage(#imageLiteral(resourceName: "YouTube"), scale: 13, orientation: (#imageLiteral(resourceName: "YouTube").imageOrientation))
        
        
//        cell.imageView?.image = newImage
//        //different image
        if(indexPath.section == 0){
            cell.backgroundColor = UIColor.white
            cell.imageView?.alpha = 1
        }
        else{
            cell.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.9)
            cell.imageView?.alpha = 0.5
        }
        return cell
    }
}

