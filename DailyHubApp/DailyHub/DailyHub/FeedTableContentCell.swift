//
//  FeedTableContentCell.swift
//  DailyHub
//
//  Created by Joe Salter on 4/3/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import UIKit

class FeedTableContentCell: UITableViewCell {
    
    var authorLabel:UILabel?
    var titleLabel:UILabel?
    var descLabel:UILabel?
    var imgView:UIImageView?
    
    var textHeight:CGFloat = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        authorLabel = UILabel()
        titleLabel = UILabel()
        descLabel = UILabel()
        imgView = UIImageView()
        imgView?.contentMode = .scaleAspectFill
        imgView?.sd_setShowActivityIndicatorView(true)
        imgView?.sd_setIndicatorStyle(.gray)
        imgView?.layer.cornerRadius = 5
        imgView?.clipsToBounds = true
        imgView?.layoutIfNeeded()
                
        titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        
        authorLabel?.font = UIFont(name: "Avenir", size: 11)
        authorLabel?.textColor = UIColor.gray
        
        descLabel?.font = UIFont(name: "Avenir", size: 12)
        descLabel?.lineBreakMode = .byWordWrapping
        descLabel?.numberOfLines = 0

        self.addSubview(titleLabel!)
        self.addSubview(authorLabel!)
        self.addSubview(descLabel!)
        self.addSubview(imgView!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
    }
}
