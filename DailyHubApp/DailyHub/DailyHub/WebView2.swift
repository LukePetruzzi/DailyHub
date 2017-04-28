//
//  WebView2.swift
//  DailyHub
//
//  Created by Joe Salter on 4/12/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import WebKit

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
        
//        headerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.9)
//        headerView.tintColor = UIColor.gray
//        footerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.9)
//        footerView.tintColor = UIColor.gray
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        headerView.effect = blurEffect
        footerView.effect = blurEffect
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        refreshButton.frame = CGRect(x: self.view.frame.size.width - 45, y: 0, width: 45, height: 45)
        refreshButton.setImage(UIImage(named: "refresh"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        refreshButton.tintColor = UIColor.gray
        headerView.addSubview(refreshButton)
        
        upButton.frame = CGRect(x: self.view.frame.size.width/2 - 50, y: 0, width: 45, height: 45)
        upButton.setImage(UIImage(named: "up"), for: .normal)
        upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
        headerView.addSubview(upButton)
        
        downButton.frame = CGRect(x: self.view.frame.size.width/2 + 5, y: 0, width: 45, height: 45)
        downButton.setImage(UIImage(named: "down"), for: .normal)
        downButton.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
        headerView.addSubview(downButton)
        
        logoButton.frame = CGRect(x: 8, y: 4, width: 100, height: 37)
        logoButton.imageView?.contentMode = .scaleAspectFit
        logoButton.setImage(UIImage(named: logoToShow), for: .normal)
        logoButton.addTarget(self, action: #selector(logoButtonTapped), for: .touchUpInside)
        footerView.addSubview(logoButton)
        
        backButton.frame = CGRect(x: self.view.frame.size.width - 130, y: 0, width: 45, height: 45)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.isEnabled = false
        footerView.addSubview(backButton)
        
        forwardButton.frame = CGRect(x: self.view.frame.size.width - 60, y: 0, width: 45, height: 45)
        forwardButton.setImage(UIImage(named: "forward"), for: .normal)
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        forwardButton.isEnabled = false
        footerView.addSubview(forwardButton)
        
        loadingIndicator.activityIndicatorViewStyle = .gray
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.frame = CGRect(x: self.view.frame.size.width - 90, y: 0, width: 45, height: 45)
        headerView.addSubview(loadingIndicator)
        
        configureUpDownButtons()
        
        let url = URL(string: urlStringToLoad)!
        webView.load(URLRequest(url: url))
        
//        headerView.bringSubview(toFront: self.view)
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
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
        self.webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 45)
        self.footerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 45, width: self.view.frame.size.width, height: 45)
        
    }
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refreshButtonTapped() {
        webView.reload()
    }
    
    func upButtonTapped() {
        
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
        }
            
        else if currPostForSite > 0 {
            currPostForSite -= 1
            let newSiteToLoad = (masterContent[logoToShow]?[currPostForSite].url)!
            let url = URL(string: newSiteToLoad)
            webView.load(URLRequest(url: url!))
            
            backButton.isEnabled = false
            forwardButton.isEnabled = false
        }
        configureUpDownButtons()
    }
    
    func downButtonTapped() {
        
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
        }
            
        else if (currPostForSite < (masterContent[logoToShow]?.count)! - 1) {
            currPostForSite += 1
            let newSiteToLoad = (masterContent[logoToShow]?[currPostForSite].url)!
            let url = URL(string: newSiteToLoad)
            webView.load(URLRequest(url: url!))
            
            backButton.isEnabled = false
            forwardButton.isEnabled = false
        }
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
    
    func backButtonTapped() {
        if (webView.canGoBack) {
            webView.goBack()
        }
        configureBackForwardButtons()
    }
    
    func forwardButtonTapped() {
        if (webView.canGoForward) {
            webView.goForward()
        }
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
