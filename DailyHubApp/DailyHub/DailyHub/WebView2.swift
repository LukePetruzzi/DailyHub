//
//  WebView2.swift
//  DailyHub
//
//  Created by Joe Salter on 4/12/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import WebKit

class CustomWebView: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView = WKWebView()
    var headerView : UIView = UIView()
    var footerView : UIView = UIView()
    
    var urlStringToLoad: String = ""
    var logoToShow: String = ""
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.backgroundColor = UIColor.clear
        headerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        footerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: statusBarHeight, width: 45, height: 45))
        closeButton.setTitleColor(UIColor.gray, for: .highlighted)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        let refreshButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 45, y: statusBarHeight, width: 45, height: 45))
        refreshButton.setImage(UIImage(named: "refresh"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        headerView.addSubview(refreshButton)
        
        let upButton = UIButton(frame: CGRect(x: self.view.frame.size.width/2 - 50, y: statusBarHeight, width: 45, height: 45))
        upButton.setImage(UIImage(named: "up"), for: .normal)
        upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
        headerView.addSubview(upButton)
        
        let downButton = UIButton(frame: CGRect(x: self.view.frame.size.width/2 + 5, y: statusBarHeight, width: 45, height: 45))
        downButton.setImage(UIImage(named: "down"), for: .normal)
        downButton.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
        headerView.addSubview(downButton)
        
        let logoButton = UIButton(frame: CGRect(x: 8, y: 4, width: 100, height: 37))
        let logoImage = logoToShow + ".png"
        logoButton.imageView?.contentMode = .scaleAspectFit
        logoButton.setImage(UIImage(named: logoImage), for: .normal)
        logoButton.addTarget(self, action: #selector(logoButtonTapped), for: .touchUpInside)
        footerView.addSubview(logoButton)
        
        let backButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 150, y: 0, width: 45, height: 45))
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        footerView.addSubview(backButton)
        
        let forwardButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 60, y: 0, width: 45, height: 45))
        forwardButton.setImage(UIImage(named: "forward"), for: .normal)
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        footerView.addSubview(forwardButton)
        
        let url = URL(string: urlStringToLoad)!
        webView.allowsBackForwardNavigationGestures = false
        webView.load(URLRequest(url: url))
        
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.webView)
        self.view.addSubview(self.footerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: statusBarHeight + 45)
        self.webView.frame = CGRect(x: 0, y: statusBarHeight + 45, width: self.view.frame.size.width, height: self.view.frame.size.height - statusBarHeight - 90)
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
        
    }
    
    func forwardButtonTapped() {
        
    }
    
    func logoButtonTapped() {
        
    }
    
}
