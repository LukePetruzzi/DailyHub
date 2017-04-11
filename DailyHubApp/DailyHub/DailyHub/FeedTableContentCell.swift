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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel(frame: CGRect(x: 5, y: 5, width: UIScreen.main.bounds.width - 10, height: 25))
        authorLabel = UILabel(frame: CGRect(x: 5, y: 30, width: UIScreen.main.bounds.width - 10, height: 15))
        descLabel = UILabel(frame: CGRect(x: 5, y: 40, width: UIScreen.main.bounds.width - 10, height: 100))
//        imgView = UIImageView()
        
        titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
//        titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        authorLabel?.font = authorLabel?.font.withSize(11)
        authorLabel?.textColor = UIColor.gray
        
        descLabel?.lineBreakMode = .byWordWrapping
        descLabel?.numberOfLines = 0
        descLabel?.sizeToFit()
//
//        titleLabel?.backgroundColor = UIColor(red:0.1, green: 0.78, blue:0.78, alpha: 1.0)
//        authorLabel?.backgroundColor = UIColor(red:0.4, green: 0.78, blue:0.78, alpha: 1.0)
//        descLabel?.backgroundColor = UIColor(red:1.0, green: 0.78, blue:0.78, alpha: 1.0)
//        imgView?.backgroundColor = UIColor(red:0.78, green: 0.78, blue:0.78, alpha: 1.0)
        
        self.addSubview(titleLabel!)
        self.addSubview(authorLabel!)
        self.addSubview(descLabel!)
//        self.addSubview(imgView!)
        
        
        
//        let views: [String: UIView] = ["t": titleLabel!, "a": authorLabel!, "d": descLabel!, "i": imgView!]
//        var constraints: [NSLayoutConstraint] = []
//        
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[t(50)]|", options: [], metrics: nil, views: views)
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[a(50)]|", options: [], metrics: nil, views: views)
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[d(50)]|", options: [], metrics: nil, views: views)
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[t][a][d][i]|", options: [], metrics: nil, views: views)
//        
//        NSLayoutConstraint.activate(constraints)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
    }
}
