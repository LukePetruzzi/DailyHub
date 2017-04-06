//
//  FeedTableTitleCell.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/3/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import UIKit

// has an image of the current site and a background color to match the site
class FeedTableTitleCell: UITableViewCell
{
    var logoImageView:UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.logoImageView = UIImageView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor(red:0.29, green: 0.29, blue:0.29, alpha: 1.0)
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
        
        logoImageView.frame = CGRect(x: 5, y: 5, width: 100, height: 20)
        self.contentView.addSubview(logoImageView)
        logoImageView.contentMode = .scaleAspectFit
    }
}
