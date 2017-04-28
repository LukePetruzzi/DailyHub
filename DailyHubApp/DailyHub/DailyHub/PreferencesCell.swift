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
        
        numPostsButton.frame = CGRect(x: self.contentView.frame.size.width-35, y: 15/2, width: 35, height: 35)
        numPostsButton.setTitleColor(UIColor.black, for: .normal)
        numPostsButton.titleLabel?.font = UIFont(name: "Avenir", size: 15)
        numPostsButton.backgroundColor = UIColor.white
        numPostsButton.layer.cornerRadius = 35/2
        numPostsButton.layer.borderColor = UIColor(red:0.00, green:0.70, blue:0.93, alpha:1.0).cgColor
        numPostsButton.layer.borderWidth = 1
        numPostsButton.layer.shadowColor = UIColor.gray.cgColor
        numPostsButton.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        numPostsButton.layer.shadowOpacity = 0.5
        numPostsButton.layer.shadowRadius = 0.5
        numPostsButton.layer.masksToBounds = false
        
        self.contentView.addSubview(dropDownButton)
        self.contentView.addSubview(logoImageView)
        self.contentView.addSubview(numPostsButton)
    }
}
