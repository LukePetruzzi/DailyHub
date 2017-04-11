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
        imgView?.contentMode = .scaleAspectFit

//        titleLabel = UILabel(frame: CGRect(x: 5, y: 5, width: UIScreen.main.bounds.width - 10, height: 25))
//        authorLabel = UILabel(frame: CGRect(x: 5, y: 30, width: UIScreen.main.bounds.width - 10, height: 15))
//        descLabel = UILabel(frame: CGRect(x: 5, y: 40, width: UIScreen.main.bounds.width - 10, height: 100))
                
        titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
//        titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        authorLabel?.font = authorLabel?.font.withSize(11)
        authorLabel?.textColor = UIColor.gray
        
        descLabel?.lineBreakMode = .byWordWrapping
        descLabel?.numberOfLines = 0
//
//        titleLabel?.backgroundColor = UIColor(red:0.1, green: 0.78, blue:0.78, alpha: 1.0)
//        authorLabel?.backgroundColor = UIColor(red:0.4, green: 0.78, blue:0.78, alpha: 1.0)
//        descLabel?.backgroundColor = UIColor(red:1.0, green: 0.78, blue:0.78, alpha: 1.0)
//        imgView?.backgroundColor = UIColor(red:0.78, green: 0.78, blue:0.78, alpha: 1.0)
        
        self.addSubview(titleLabel!)
        self.addSubview(authorLabel!)
        self.addSubview(descLabel!)
        self.addSubview(imgView!)
        
//        let verticalConstraint1 = NSLayoutConstraint(item: authorLabel!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: titleLabel!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
//        let verticalConstraint2 = NSLayoutConstraint(item: descLabel!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: authorLabel!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
//        let verticalConstraint3 = NSLayoutConstraint(item: imgView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: descLabel!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
//
//        self.contentView.addConstraints([verticalConstraint1, verticalConstraint2, verticalConstraint3])
        
//        let views: [String: UIView] = ["t": titleLabel!, "a": authorLabel!, "d": descLabel!, "i": imgView!]
//        var constraints: [NSLayoutConstraint] = []
//        
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[t]-10-[a]-10-[d]-10-[i]|", options: [], metrics: nil, views: views)
//        
//        NSLayoutConstraint.activate(constraints)
//
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
    }
}
