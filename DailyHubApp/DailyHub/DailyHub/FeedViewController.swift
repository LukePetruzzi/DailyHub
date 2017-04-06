//
//  FeedViewController
//  DailyHub
//
//  Created by Luke Petruzzi on 3/24/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit
import Foundation

class FeedViewController: UIViewController {
    
    var tableView: UITableView = {
        var tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Database.getDatabaseInfo(completionHandler: {(data, error) in
//            if let d = data {
//                print(d)
//            }
//        })
                
        self.view.backgroundColor = UIColor(red:0.29, green: 0.29, blue:0.29, alpha: 1.0)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

