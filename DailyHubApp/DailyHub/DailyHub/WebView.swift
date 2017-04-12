//
//  ViewController.swift
//  InAppBrowser
//
//  Created by Ananya Joshi on 4/5/17.
//  Copyright © 2017 Ananya Joshi. All rights reserved.
//

import UIKit
import WebKit


class WebViewC: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    var urlStringToLoad: String!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var logoColor = [#imageLiteral(resourceName: "YouTube"):"red", #imageLiteral(resourceName: "AP"):"Black", #imageLiteral(resourceName: "BBCNews"):"Black", #imageLiteral(resourceName: "BBCSport"):"Yellow", #imageLiteral(resourceName: "Bloomberg"): "Black", #imageLiteral(resourceName: "BusinessInsider"):"Blue", #imageLiteral(resourceName: "Buzzfeed"):"red", #imageLiteral(resourceName: "CNN"):"red", #imageLiteral(resourceName: "Deviant"):"green", #imageLiteral(resourceName: "EntertainmentWeekly"):"black", #imageLiteral(resourceName: "ESPN"):"red", #imageLiteral(resourceName: "Etsy"):"orange", #imageLiteral(resourceName: "Giphy"):"black", #imageLiteral(resourceName: "HackerNews"):"orange" , #imageLiteral(resourceName: "IGN"):"red", #imageLiteral(resourceName: "Imgur"):"green", #imageLiteral(resourceName: "MTV"):"black", #imageLiteral(resourceName: "NationalGeographic"):"yellow", #imageLiteral(resourceName: "Newsweek"):"red", #imageLiteral(resourceName: "NYMag"):"black",  #imageLiteral(resourceName: "NYTimes"):"black", #imageLiteral(resourceName: "Reuters"):"orange", #imageLiteral(resourceName: "Soundcloud"):"orange",#imageLiteral(resourceName: "Spotify"):"green", #imageLiteral(resourceName: "StackOverflow"):"orange", #imageLiteral(resourceName: "Techcrunch"):"green", #imageLiteral(resourceName: "Time"):"red", #imageLiteral(resourceName: "USAToday"):"blue", #imageLiteral(resourceName: "Vimeo"):"blue", #imageLiteral(resourceName: "WashPost"):"black", #imageLiteral(resourceName: "WSJ"):"black"]
       // println(logoColor[#imageLiteral(resourceName: "YouTube")])
        
       // var color = UIColor.col2
        
        var populatedDictionary = ["key1": "value1", "key2": "value2"]
        print(populatedDictionary["key1"])
        
        let refButton : UIBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTap))
        //REMMEBER TO SET THESE COLORS
        //REMEMBER TO SET THE COMPLIMENTARY BACKGROUND COLOR
        //THE TWO MUST BE COMPLIMENTARY
        //rename the logos to match the site
        //integrate
       // navigationController?.navigationBar.barTintColor = color
      
        let upPic = UIImage(named: "up")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let scaledIconU = UIImage(cgImage: (upPic?.cgImage!)!, scale: 13, orientation: (upPic?.imageOrientation)!)
        
        
        let upButton : UIBarButtonItem = UIBarButtonItem(image: scaledIconU, style: .plain, target: self, action: #selector(refreshTap))
        
        
        let dwPic = UIImage(named: "down")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let scaledIconD = UIImage(cgImage: (dwPic?.cgImage!)!, scale: 13, orientation: (dwPic?.imageOrientation)!)
        
        let dwButton : UIBarButtonItem = UIBarButtonItem(image: scaledIconD, style: .plain, target: self, action: #selector(refreshTap))
        
        let lPic = UIImage(named: "left")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let scaledIconL = UIImage(cgImage: (lPic?.cgImage!)!, scale: 13, orientation: (lPic?.imageOrientation)!)
        
        let lButton : UIBarButtonItem = UIBarButtonItem(image: scaledIconL, style: .plain, target: self, action: #selector(backTap))
        
        let rPic = UIImage(named: "right")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let scaledIconR = UIImage(cgImage: (rPic?.cgImage!)!, scale: 13, orientation: (rPic?.imageOrientation)!)
        
        let rButton : UIBarButtonItem = UIBarButtonItem(image: scaledIconR, style: .plain, target: self, action: #selector(forwardTap))
        
        //let doneButtonAsLeftArrow = UIBarButtonItem(image: scaledIcon, style: .plain, target: self, action: nil)
        let buttomIn = UIImage(named: "Soundcloud")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let scaledIcon = UIImage(cgImage: (buttomIn?.cgImage!)!, scale: 7, orientation: (buttomIn?.imageOrientation)!)
        //take back to soundcloud.com
        let logo = UIBarButtonItem(image: scaledIcon, style: .plain, target: self, action: #selector(tapLogo))
        
        let logo2 = UIBarButtonItem(image: scaledIcon, style: .plain, target: self, action: #selector(tapLogo))
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        let toolBar = UIToolbar()
        toolBar.setItems([logo2], animated: true)
        self.view.addSubview(toolBar)
        
       
        navigationItem.setLeftBarButton(logo, animated: true)
        navigationItem.rightBarButtonItems = [refButton, rButton, lButton, dwButton,  upButton]
        let url = URL(string: urlStringToLoad)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false

    }
    
    func tapLogo(){
        let url = URL(string: "https://www.google.com")!
        webView.load(URLRequest(url: url))
    }
    func backTap(){
        if (webView.canGoBack) {
            webView.goBack()

        }
    }
    
    func forwardTap(){
        if (webView.canGoForward) {
            webView.goForward()
            
        }
    }
    
    func refreshTap(){
            webView.reload()
        
    }
   
    
}

