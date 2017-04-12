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
    
    var urlStringToLoad: String = "www.google.com"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        
    }
    
}
