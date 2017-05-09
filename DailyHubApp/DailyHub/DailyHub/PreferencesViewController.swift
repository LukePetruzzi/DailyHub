//
//  PreferencesViewController.swift
//  DailyHub
//
//  Created by Joe Salter on 4/19/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    public var sections = ["In Feed", "Not In Feed"]

    var userSitePrefs:[Array<SitePref>] = []

    var delegate: FeedViewController?
    
    private var tableView: UITableView!
    
    var checkView: UIButton = UIButton()
    var closeView: UIButton = UIButton()
    var numPostView: UIVisualEffectView = UIVisualEffectView()
    var pickerView: UIPickerView = UIPickerView()
    var logoView: UIImageView = UIImageView()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the user preferences right when view loads
        userSitePrefs = CognitoUserManager.sharedInstance.retrieveUserSitePrefs(feedNumber: 0)!
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PreferencesCell.self, forCellReuseIdentifier: "PreferencesCell")
        tableView.setEditing(true, animated: true)
        tableView.isScrollEnabled = true
        
        checkView.backgroundColor = UIColor(red:0.00, green:1.00, blue:0.60, alpha:1.0)
        checkView.setImage(UIImage(named: "whiteCheck"), for: .normal)
        checkView.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        closeView.backgroundColor = UIColor(red:1.00, green:0.32, blue:0.32, alpha:1.0)
        closeView.setImage(UIImage(named: "whiteClose"), for: .normal)
        closeView.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        numPostView.frame = self.view.frame;
        let blurEffect = UIBlurEffect(style: .dark)
        numPostView.effect = blurEffect
        numPostView.isHidden = true
        numPostView.tag = 0
        
        pickerView.frame = CGRect(x: self.view.bounds.width/2 - 40, y: self.view.bounds.height/2 - 100, width: 80, height: 200)
        pickerView.dataSource = self
        pickerView.delegate = self
        numPostView.addSubview(pickerView)
        
        let closePickerButton = UIButton(frame: CGRect(x: self.view.bounds.width/2 - 25, y: self.view.bounds.height/2 + 100, width: 50, height: 50))
        closePickerButton.setImage(UIImage(named: "checkCircleWhite1"), for: .normal)
        closePickerButton.addTarget(self, action: #selector(closePickerTapped), for: .touchUpInside)
        numPostView.addSubview(closePickerButton)
        
        logoView.frame = CGRect(x: 100, y: self.view.bounds.height/2 - 150, width: self.view.bounds.width - 200, height: 50)
        logoView.contentMode = .scaleAspectFit
        numPostView.addSubview(logoView)

        self.view.addSubview(checkView)
        self.view.addSubview(closeView)
        self.view.addSubview(tableView)
        self.view.addSubview(numPostView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        checkView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height: 45)
        closeView.frame = CGRect(x: self.view.frame.size.width/2, y: 0, width: self.view.frame.size.width/2, height: 45)
        tableView.frame = CGRect(x: 0, y: 45, width: self.view.frame.width, height: self.view.frame.height - 45)
    }
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkButtonTapped() {
        CognitoUserManager.sharedInstance.updateUserSitePrefs(newPrefs: userSitePrefs)
        delegate?.userSitePrefs = userSitePrefs[0]
        delegate?.refreshTable()
        delegate?.tableView?.setContentOffset(CGPoint.zero, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func closePickerTapped() {
        
        userSitePrefs[0][numPostView.tag].numPosts = pickerView.selectedRow(inComponent: 0) + 1
        tableView.reloadData()
        self.view.sendSubview(toBack: numPostView)
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
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
        cell.logoImageView.setImage(image, for: .normal)
        
        if (indexPath.section == 0) {
            
            cell.dropDownButton.setImage(UIImage(named: "close1"), for: .normal)
            cell.dropDownButton.tag = indexPath.row
            cell.dropDownButton.removeTarget(self, action: #selector(moveToTop), for: .touchUpInside)
            cell.dropDownButton.addTarget(self, action: #selector(moveToBottom), for: .touchUpInside)
            
            cell.numPostsButton.isHidden = false
            cell.numPostsButton.tag = indexPath.row
            cell.numPostsButton.addTarget(self, action: #selector(numPostsButtonTapped), for: .touchUpInside)
            cell.numPostsButton.setTitle(String(userSitePrefs[indexPath.section][indexPath.row].numPosts), for: .normal)
            
            cell.logoImageView.tag = indexPath.row
            cell.logoImageView.addTarget(self, action: #selector(logoTappedForCell), for: .touchDownRepeat)
        }
        else {
            cell.dropDownButton.setImage(UIImage(named: "up1"), for: .normal)
            cell.dropDownButton.tag = indexPath.row
            cell.dropDownButton.removeTarget(self, action: #selector(moveToBottom), for: .touchUpInside)
            cell.dropDownButton.addTarget(self, action: #selector(moveToTop), for: .touchUpInside)
            cell.numPostsButton.isHidden = true
        }
        
        if(indexPath.section == 0){
            cell.backgroundColor = UIColor.white
        }
        else{
            cell.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.9)
        }
        return cell
    }
    
    func logoTappedForCell(sender: UIButton) {
        let sourceItem = userSitePrefs[0][sender.tag]
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            self.tableView.reloadData()
        })
        
        tableView.beginUpdates()
        userSitePrefs[0].remove(at: sender.tag)
        userSitePrefs[0].insert(sourceItem, at: 0)
        
        let sourceIndexPath = IndexPath(row: sender.tag, section: 0)
        let destIndexPath = IndexPath(row: 0, section: 0)
        
        tableView.moveRow(at: sourceIndexPath, to: destIndexPath)
        tableView.endUpdates()
        
        CATransaction.commit()
    }
    
    func moveToBottom(sender: UIButton) {
        
        let sourceItem = userSitePrefs[0][sender.tag]
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            self.tableView.reloadData()
        })
        
        tableView.beginUpdates()
        userSitePrefs[0].remove(at: sender.tag)
        userSitePrefs[1].append(sourceItem)
        
        let sourceIndexPath = IndexPath(row: sender.tag, section: 0)
        let destIndexPath = IndexPath(row: userSitePrefs[1].count-1, section: 1)

        tableView.moveRow(at: sourceIndexPath, to: destIndexPath)
        tableView.endUpdates()
       
        CATransaction.commit()

        
    }
    
    func moveToTop(sender: UIButton) {
        
        let sourceItem = userSitePrefs[1][sender.tag]
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            self.tableView.reloadData()
        })
        
        tableView.beginUpdates()
        userSitePrefs[1].remove(at: sender.tag)
        userSitePrefs[0].append(sourceItem)
       
        let sourceIndexPath = IndexPath(row: sender.tag, section: 1)
        let destIndexPath = IndexPath(row: userSitePrefs[0].count-1, section: 0)
        
        tableView.moveRow(at: sourceIndexPath, to: destIndexPath)
        tableView.endUpdates()
        
        CATransaction.commit()
        
    }
    
    func numPostsButtonTapped(sender: UIButton) {
        numPostView.isHidden = false
        numPostView.tag = sender.tag
        let imageString = userSitePrefs[0][sender.tag].siteName
        logoView.image = UIImage(named: imageString)
        pickerView.selectRow(userSitePrefs[0][sender.tag].numPosts-1, inComponent: 0, animated: false)
        self.view.bringSubview(toFront: numPostView)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let value = row + 1
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        let str = NSAttributedString(string: String(value), attributes: [NSForegroundColorAttributeName: UIColor.white, NSParagraphStyleAttributeName: style])
        return str
    }

}

