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

    var siteDataIsFrom:String
    var siteImage:UIImage
    var logoImageView:UIImageView
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, siteDataIsFrom:String) {
        self.siteDataIsFrom = siteDataIsFrom
        self.siteImage = UIImage(named: siteDataIsFrom + ".png")!
        self.logoImageView = UIImageView(image: self.siteImage)
        
        // conform to tableviewcell stuff
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.arrangeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func prepareForReuse() {
        
        super.prepareForReuse()
    }
    
    internal func arrangeUI(){
        
        logoImageView.frame = CGRect(x: 0, y: 0, width: 200, height: 75)
        self.contentView.addSubview(logoImageView)
    }
}
