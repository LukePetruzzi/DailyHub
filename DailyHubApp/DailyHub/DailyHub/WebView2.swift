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
    var headerView: UIView = UIView()
    var footerView: UIView = UIView()
    var closeButton: UIButton = UIButton()
    var refreshButton: UIButton = UIButton()
    var upButton: UIButton = UIButton()
    var downButton: UIButton = UIButton()
    var logoButton: UIButton = UIButton()
    var backButton: UIButton = UIButton()
    var forwardButton: UIButton = UIButton()
    
    var urlStringToLoad: String = ""
    var logoToShow: String = ""
    
    private var lastContentOffset: CGFloat = 0
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.backgroundColor = UIColor.white
        webView.scrollView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
        webView.scrollView.layer.masksToBounds = false
        
        headerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.9)
        headerView.tintColor = UIColor.gray
        footerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.9)
        footerView.tintColor = UIColor.gray
        
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
        let logoImage = logoToShow + ".png"
        logoButton.imageView?.contentMode = .scaleAspectFit
        logoButton.setImage(UIImage(named: logoImage), for: .normal)
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
        
        let url = URL(string: urlStringToLoad)!
//        webView.allowsBackForwardNavigationGestures = false
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
//        self.webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.footerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 45, width: self.view.frame.size.width, height: 45)
        
    }
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refreshButtonTapped() {
        webView.reload()
    }
    
    func upButtonTapped() {
        
    }
    
    func downButtonTapped() {
        
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
    
    func logoButtonTapped() {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        configureBackForwardButtons()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("last \(lastContentOffset)")
//        print("new \(scrollView.contentOffset.y)")
//        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            self.headerView.isHidden = true
//            self.footerView.isHidden = true
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.y) {
//            self.headerView.isHidden = false
//            self.footerView.isHidden = false
//        }
//        
//        // update the new position acquired
//        self.lastContentOffset = scrollView.contentOffset.y
//    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
        
    }
}
