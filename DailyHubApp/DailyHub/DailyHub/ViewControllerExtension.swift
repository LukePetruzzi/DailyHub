//
//  ViewControllerExtension.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 5/2/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import UIKit

public let LOADING_OVERLAY_VIEW_TAG = 987432

extension UIViewController
{

    func showAlertWithError(_ error:NSError?, stringBeforeMessage:String?)
    {
        var preErrorString = stringBeforeMessage
        
        if stringBeforeMessage == nil{
            preErrorString = ""
        }
        
        if error != nil{
            let alert = UIAlertController(title: "Sorry", message: "\(preErrorString!)\n\(error!.localizedDescription)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            // show the alert to the calling viewController
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Sorry", message: "\(preErrorString!)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            // show the alert to the calling viewController
            self.present(alert, animated: true, completion: nil)
        }
    }
}
