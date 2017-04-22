//
//  PreferencesViewController.swift
//  DailyHub
//
//  Created by Joe Salter on 4/19/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public var sections = ["In Queue", "Wannabe"]
    public var Array  = [[#imageLiteral(resourceName: "YouTube"), #imageLiteral(resourceName: "AP"), #imageLiteral(resourceName: "BBCNews"), #imageLiteral(resourceName: "BBCSport"), #imageLiteral(resourceName: "Bloomberg"), #imageLiteral(resourceName: "BusinessInsider"), #imageLiteral(resourceName: "Buzzfeed"), #imageLiteral(resourceName: "CNN"), #imageLiteral(resourceName: "Deviant"), #imageLiteral(resourceName: "EntertainmentWeekly"), #imageLiteral(resourceName: "ESPN"), #imageLiteral(resourceName: "Etsy"), #imageLiteral(resourceName: "Giphy"), #imageLiteral(resourceName: "HackerNews"), #imageLiteral(resourceName: "IGN"), #imageLiteral(resourceName: "Imgur"), #imageLiteral(resourceName: "MTV"), #imageLiteral(resourceName: "NationalGeographic"), #imageLiteral(resourceName: "Newsweek"), #imageLiteral(resourceName: "NYMag"),  #imageLiteral(resourceName: "NYTimes"), #imageLiteral(resourceName: "Reuters"), #imageLiteral(resourceName: "Soundcloud"),#imageLiteral(resourceName: "Spotify"), #imageLiteral(resourceName: "StackOverflow"), #imageLiteral(resourceName: "Techcrunch"), #imageLiteral(resourceName: "Time"), #imageLiteral(resourceName: "USAToday"), #imageLiteral(resourceName: "Vimeo"), #imageLiteral(resourceName: "WashPost"), #imageLiteral(resourceName: "WSJ")],[]]
    
    private var myTableView: UITableView!
    
    var headerView: UIView = UIView()
    var closeButton: UIButton = UIButton()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.setEditing(true, animated: true)
        myTableView.isScrollEnabled = true
        
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
        headerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.9)
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        self.view.addSubview(headerView)
        self.view.addSubview(myTableView)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
        myTableView.frame = CGRect(x: 0, y: 45, width: self.view.frame.width, height: self.view.frame.height - 45)
    }
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
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
            let sourceItem = Array[sourceIndexPath.section][sourceIndexPath.row]
            Array[sourceIndexPath.section].remove(at: sourceIndexPath.row )
            Array[destinationIndexPath.section].insert(sourceItem, at: destinationIndexPath.row)
            tableView.reloadData()
            print ("HET")
        }
        print (Array)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(Array[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        //cell.textLabel!.text = "\(Array[indexPath.section][indexPath.row])"
        let ImageA = Array[indexPath.section][indexPath.row]
        
        let frame = tableView.rectForRow(at: indexPath)
        
        let widthRatio = 0.6 * frame.size.width / ImageA.size.width
        let heightRatio = 0.8 * frame.size.height / ImageA.size.height
        
        var newSize: CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: ImageA.size.width * heightRatio, height: ImageA.size.height * heightRatio)
        } else {
            newSize = CGSize(width: ImageA.size.width * widthRatio, height: ImageA.size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        UIGraphicsGetCurrentContext()?.interpolationQuality = .high
        ImageA.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        
        
        
        
        // UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        // ImageA.draw(in: rect)
        // let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // UIGraphicsEndImageContext()
        //UIImage(data: #imageLiteral(resourceName: "YouTube"), scale: 13)
        //let scaledIconD = UIImage(#imageLiteral(resourceName: "YouTube"), scale: 13, orientation: (#imageLiteral(resourceName: "YouTube").imageOrientation))
        
        
        cell.imageView?.image = newImage
        //different image
        if(indexPath.section == 0){
            cell.backgroundColor = UIColor.white
            cell.imageView?.alpha = 1
        }
        else{
            cell.backgroundColor = UIColor.lightGray
            cell.imageView?.alpha = 0.5
        }
        return cell
    }
}

