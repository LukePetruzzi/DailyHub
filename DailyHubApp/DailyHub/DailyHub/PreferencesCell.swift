//
//  PreferencesCell.swift
//  DailyHub
//
//  Created by Joe Salter on 4/24/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import UIKit

// has an image of the current site and a background color to match the site
class PreferencesCell: UITableViewCell
{
    var dropDownButton:UIButton = UIButton()
    var logoImageView:UIImageView = UIImageView()
    var numPostsButton:UIButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red:0.78, green: 0.78, blue:0.78, alpha: 0.6)
        self.arrangeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func prepareForReuse() {
        
        super.prepareForReuse()
    }
    
    // arrange the UI elements
    internal func arrangeUI(){
        
        dropDownButton.frame = CGRect(x: 10, y: 15, width: 20, height: 20)
        
//        logoImageView.frame = CGRect(x: 50, y: 5, width: 100, height: 40)
        logoImageView.contentMode = .scaleAspectFit
        
        numPostsButton.frame = CGRect(x: 155, y: 0, width: self.contentView.frame.size.width-25, height: 50)
        numPostsButton.setTitleColor(UIColor.black, for: .normal)
        numPostsButton.titleLabel?.font = UIFont(name: "Avenir", size: 16)
        
        self.contentView.addSubview(dropDownButton)
        self.contentView.addSubview(logoImageView)
        self.contentView.addSubview(numPostsButton)
    }
}
