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
    
    var author:UILabel?
    var title:UILabel?
    var url:String?
    var thumbnail:String?
    var desc:String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        self.contentView.addSubview(title!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
    }
}
