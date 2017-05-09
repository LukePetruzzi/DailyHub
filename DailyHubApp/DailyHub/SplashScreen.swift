//
//  SplashScreen.swift
//  DailyHub
//
//  Created by Joe Salter on 5/8/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit

class SplashScreen: UIViewController {

    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.view.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
        self.view.backgroundColor = UIColor.white
        loadingIndicator.frame = self.view.frame
        loadingIndicator.activityIndicatorViewStyle = .gray
        loadingIndicator.startAnimating()
        
        self.view.addSubview(loadingIndicator)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
