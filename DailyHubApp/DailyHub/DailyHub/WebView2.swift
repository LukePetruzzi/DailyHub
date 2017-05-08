//
//  WebView2.swift
//  DailyHub
//
//  Created by Joe Salter on 4/12/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import WebKit
import FirebaseAnalytics
import FirebaseDatabase
import FBSDKLoginKit

class CustomWebView: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    
    var webView: WKWebView = WKWebView()
    var headerView: UIVisualEffectView = UIVisualEffectView()
    var footerView: UIVisualEffectView = UIVisualEffectView()
    var closeButton: UIButton = UIButton()
    var refreshButton: UIButton = UIButton()
    var upButton: UIButton = UIButton()
    var downButton: UIButton = UIButton()
    var logoButton: UIButton = UIButton()
    var backButton: UIButton = UIButton()
    var forwardButton: UIButton = UIButton()
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    var user : String = ""
    
    var urlStringToLoad: String = ""
    var logoToShow: String = ""
    var masterContent = [String:[ContentInfo]]()
    var userSitePrefs = [SitePref]()
    var currSite: Int = 0
    var currPostForSite: Int = 0
    
    private var lastContentOffset: CGFloat = 0
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.backgroundColor = UIColor.white
        webView.scrollView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
        webView.scrollView.layer.masksToBounds = false
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        headerView.effect = blurEffect
        footerView.effect = blurEffect
        
        closeButton.setImage(UIImage(named: "close1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = UIColor.black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDown)
        closeButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDragEnter)
        closeButton.addTarget(self, action: #selector(changeTintColorBlack), for: .touchDragExit)
        headerView.addSubview(closeButton)
        
        refreshButton.setImage(UIImage(named: "refresh1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        refreshButton.tintColor = UIColor.black
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDown)
        refreshButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDragEnter)
        refreshButton.addTarget(self, action: #selector(changeTintColorBlack), for: .touchDragExit)
        headerView.addSubview(refreshButton)
        
        upButton.setImage(UIImage(named: "up1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        upButton.tintColor = UIColor.black
        upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
        upButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDown)
        upButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDragEnter)
        upButton.addTarget(self, action: #selector(changeTintColorBlack), for: .touchDragExit)
        headerView.addSubview(upButton)
        
        downButton.setImage(UIImage(named: "down1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        downButton.tintColor = UIColor.black
        downButton.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
        downButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDown)
        downButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDragEnter)
        downButton.addTarget(self, action: #selector(changeTintColorBlack), for: .touchDragExit)
        headerView.addSubview(downButton)
        
        logoButton.frame = CGRect(x: 8, y: 4, width: 100, height: 37)
        logoButton.imageView?.contentMode = .scaleAspectFit
        logoButton.setImage(UIImage(named: logoToShow), for: .normal)
        logoButton.addTarget(self, action: #selector(logoButtonTapped), for: .touchUpInside)
        footerView.addSubview(logoButton)
        
        backButton.setImage(UIImage(named: "left1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = UIColor.black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDown)
        backButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDragEnter)
        backButton.addTarget(self, action: #selector(changeTintColorBlack), for: .touchDragExit)
        backButton.isEnabled = false
        footerView.addSubview(backButton)
        
        forwardButton.setImage(UIImage(named: "right1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        forwardButton.tintColor = UIColor.black
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDown)
        forwardButton.addTarget(self, action: #selector(changeTintColorGray), for: .touchDragEnter)
        forwardButton.addTarget(self, action: #selector(changeTintColorBlack), for: .touchDragExit)
        forwardButton.isEnabled = false
        footerView.addSubview(forwardButton)
        
        loadingIndicator.activityIndicatorViewStyle = .gray
        loadingIndicator.hidesWhenStopped = true
        headerView.addSubview(loadingIndicator)
        
        configureUpDownButtons()
        
        let url = URL(string: urlStringToLoad)!
        webView.load(URLRequest(url: url))
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.footerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 45)
        footerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 45, width: self.view.frame.size.width, height: 45)
        closeButton.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        refreshButton.frame = CGRect(x: self.view.frame.size.width - 45, y: 0, width: 45, height: 45)
        upButton.frame = CGRect(x: self.view.frame.size.width/2 - 55, y: 0, width: 45, height: 45)
        downButton.frame = CGRect(x: self.view.frame.size.width/2 + 10, y: 0, width: 45, height: 45)
        backButton.frame = CGRect(x: self.view.frame.size.width - 150, y: 5, width: 35, height: 35)
        forwardButton.frame = CGRect(x: self.view.frame.size.width - 60, y: 5, width: 35, height: 35)
        loadingIndicator.frame = CGRect(x: self.view.frame.size.width - 90, y: 0, width: 45, height: 45)
    }
    
    func changeTintColorGray(sender: UIButton) {
        sender.tintColor = UIColor.lightGray
    }
    
    func changeTintColorBlack(sender: UIButton) {
        sender.tintColor = UIColor.black
    }
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refreshButtonTapped(sender:UIButton) {
        sender.tintColor = UIColor.black
        webView.reload()
    }
    
    
    
    
    
    
    
    
    
    func loadFacebookData(completion: @escaping ((_ error:NSError?) -> Void))
    {
        var userId:String? = nil
        var userName:String? = nil
        
        // wait to load the image and name
        let waitGroup = DispatchGroup()
        waitGroup.enter()
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, relationship_status"]).start(completionHandler: {(connection, result, error) -> Void in
            if ((error) != nil)
            {
                completion(error! as NSError)
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
                self.user = userId!
                completion(nil)
            }
        }
        
    }
    
    
    
    func upButtonTapped(sender: UIButton) {
        
        if (currSite > 0) {
            var newSiteToLoad: String = ""
            if (currPostForSite > 0) {
                currPostForSite -= 1
            }
            else {
                currSite = currSite - 1
                logoToShow = userSitePrefs[currSite].siteName
                currPostForSite = (masterContent[logoToShow]?.count)! - 1
            }
            newSiteToLoad = (masterContent[logoToShow]?[currPostForSite].url)!
            let url = URL(string: newSiteToLoad)
            webView.load(URLRequest(url: url!))
            logoButton.setImage(UIImage(named: logoToShow), for: .normal)
            
            backButton.isEnabled = false
            forwardButton.isEnabled = false
            let newsItem = masterContent[logoToShow]?[currPostForSite]
            
            
            let formatter = DateFormatter()
            formatter.timeStyle = .full
            formatter.dateStyle = .full
            let dater = formatter.string(from: NSDate() as Date)
            
            let newsValues = [
                "title": newsItem?.title,
                "author": newsItem?.author,
                "url": newsItem?.url,
                "thumbnail":newsItem?.thumbnail,
                "description":newsItem?.description,
                "time": dater]
            loadFacebookData(completion: {(err) -> Void in
                if err != nil{
                    print("ERROR GETTIN FACEBOOK NAME: \(err!)")
                }
                else{
                    let USERTIME = dater + self.user
                    self.ref?.updateChildValues([
                        USERTIME: newsValues
                        ])
                }
            })
        }
            
            
            
        else if currPostForSite > 0 {
            currPostForSite -= 1
            let newSiteToLoad = (masterContent[logoToShow]?[currPostForSite].url)!
            let url = URL(string: newSiteToLoad)
            webView.load(URLRequest(url: url!))
            
            backButton.isEnabled = false
            forwardButton.isEnabled = false
        }
        sender.tintColor = UIColor.black
        configureUpDownButtons()
    }
    
    func downButtonTapped(sender: UIButton) {
        
        if (currSite < userSitePrefs.count - 1) {
            var newSiteToLoad: String = ""
            if (currPostForSite < (masterContent[logoToShow]?.count)! - 1) {
                currPostForSite += 1
            }
            else {
                currSite = currSite + 1
                logoToShow = userSitePrefs[currSite].siteName
                currPostForSite = 0
            }
            newSiteToLoad = (masterContent[logoToShow]?[currPostForSite].url)!
            let url = URL(string: newSiteToLoad)
            webView.load(URLRequest(url: url!))
            logoButton.setImage(UIImage(named: logoToShow), for: .normal)
            
            backButton.isEnabled = false
            forwardButton.isEnabled = false
            
            let newsItem = masterContent[logoToShow]?[currPostForSite]
            
            
            let formatter = DateFormatter()
            formatter.timeStyle = .full
            formatter.dateStyle = .full
            let dater = formatter.string(from: NSDate() as Date)
            
            let newsValues = [
                "title": newsItem?.title,
                "author": newsItem?.author,
                "url": newsItem?.url,
                "thumbnail":newsItem?.thumbnail,
                "description":newsItem?.description,
                "time": dater]
            loadFacebookData(completion: {(err) -> Void in
                if err != nil{
                    print("ERROR GETTIN FACEBOOK NAME: \(err!)")
                }
                else{
                    let USERTIME = dater + self.user
                    self.ref?.updateChildValues([
                        USERTIME: newsValues
                        ])
                }
            })
            
        }
            
        else if (currPostForSite < (masterContent[logoToShow]?.count)! - 1) {
            currPostForSite += 1
            let newSiteToLoad = (masterContent[logoToShow]?[currPostForSite].url)!
            let url = URL(string: newSiteToLoad)
            webView.load(URLRequest(url: url!))
            
            backButton.isEnabled = false
            forwardButton.isEnabled = false
        }
        sender.tintColor = UIColor.black
        configureUpDownButtons()
    }
    
    func configureUpDownButtons() {
        if (currSite == 0 && currPostForSite == 0) {
            upButton.isEnabled = false
        }
        else {
            upButton.isEnabled = true
        }
        
        if (currSite == userSitePrefs.count - 1 && currPostForSite == userSitePrefs[userSitePrefs.count - 1].numPosts - 1) {
            downButton.isEnabled = false
        }
        else {
            downButton.isEnabled = true
        }
    }
    
    func backButtonTapped(sender: UIButton) {
        if (webView.canGoBack) {
            webView.goBack()
        }
        sender.tintColor = UIColor.black
        configureBackForwardButtons()
    }
    
    func forwardButtonTapped(sender: UIButton) {
        if (webView.canGoForward) {
            webView.goForward()
        }
        sender.tintColor = UIColor.black
        configureBackForwardButtons()
    }
    
    func configureBackForwardButtons() {
        if (webView.canGoBack) {
            backButton.isEnabled = true
        }
        else {
            backButton.isEnabled = false
        }
        
        if (webView.canGoForward) {
            forwardButton.isEnabled = true
        }
        else {
            forwardButton.isEnabled = false
        }
    }
    
    func logoButtonTapped() {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadingIndicator.startAnimating()
        configureBackForwardButtons()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        loadingIndicator.stopAnimating()
        configureBackForwardButtons()
    }
}
