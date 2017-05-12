//
//  TabControllerExtension.swift
//  DailyHub
//
//  Created by Joe Salter on 5/12/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let selectedVC = selectedViewController{
                return selectedVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let selectedVC = selectedViewController{
                return selectedVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let selectedVC = selectedViewController{
                return selectedVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
}
