//
//  FeedTableContentCell.swift
//  DailyHub
//
//  Created by Joe Salter on 4/3/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import UIKit

private struct Metrics{
    static let LEADING_OR_TRAILING:CGFloat = 8
    static let ABOVE_OR_BELOW:CGFloat = 6
}

class FeedTableContentCell: UITableViewCell {
    
    
    var authorLabel:UILabel!
    var titleLabel:UILabel!
    var descLabel:UILabel!
    var imgView:UIImageView!
    
    var textHeight:CGFloat = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        self.authorLabel = UILabel()
        self.titleLabel = UILabel()
        self.descLabel = UILabel()
        self.imgView = UIImageView()
        
        // Title Label
        titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
        
        
        // Author Label
        authorLabel?.font = UIFont(name: "Avenir", size: 11)
        authorLabel?.textColor = UIColor.gray
        authorLabel?.lineBreakMode = .byWordWrapping
        authorLabel?.numberOfLines = 0
        
        
        // Description Label
        descLabel?.font = UIFont(name: "Avenir", size: 12)
        descLabel?.lineBreakMode = .byWordWrapping
        descLabel?.numberOfLines = 0
        
        
        // Image View
        imgView?.contentMode = .scaleAspectFill
        imgView?.sd_setShowActivityIndicatorView(true)
        imgView?.sd_setIndicatorStyle(.gray)
        imgView?.layer.cornerRadius = 5
        imgView?.clipsToBounds = true
        
        // add the subviews
        self.contentView.addSubview(titleLabel!)
        self.contentView.addSubview(authorLabel!)
        self.contentView.addSubview(descLabel!)
        self.contentView.addSubview(imgView!)
        
        // get rid of constraints I DIDN'T FRIGGIN MAKE
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        for sub in self.contentView.subviews{
            sub.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // create constraints for the content view itself
        self.contentView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)

        // titleLabel
        // top
        self.contentView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.titleLabel!, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        // bottom
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.authorLabel!, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        // authorLabel
        // top
        self.contentView.addConstraint(NSLayoutConstraint(item: self.authorLabel!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.titleLabel!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        // bottom
        self.contentView.addConstraint(NSLayoutConstraint(item: self.authorLabel!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.descLabel!, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        // descLabel
        // top
        self.contentView.addConstraint(NSLayoutConstraint(item: self.descLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.authorLabel!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        // bottom
        self.contentView.addConstraint(NSLayoutConstraint(item: self.descLabel!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.imgView!, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        // height
        self.contentView.addConstraint(NSLayoutConstraint(item: self.descLabel!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100))
       
        
        // imgView
        // top
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imgView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.descLabel!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        // bottom
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imgView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0 - Metrics.ABOVE_OR_BELOW))
        // height
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imgView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300 - Metrics.ABOVE_OR_BELOW ))
        
        
        // set all subviews left and right constraints to the sides
        for sub in self.contentView.subviews{
            
            // leading
            self.contentView.addConstraint(NSLayoutConstraint(item: sub, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0 + Metrics.LEADING_OR_TRAILING))
            // trailing
            self.contentView.addConstraint(NSLayoutConstraint(item: sub, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0 - Metrics.LEADING_OR_TRAILING))
            
            // width
            self.contentView.addConstraint(NSLayoutConstraint(item: sub, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.contentView.bounds.width - Metrics.LEADING_OR_TRAILING * 2))
            
            
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//
//    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
    }
}
