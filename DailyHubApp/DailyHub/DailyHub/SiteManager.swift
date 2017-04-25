//
//  SiteManager.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/24/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation

class SiteManager
{
    // Can't init, is singleton
    private init() { }
    static let sharedInstance: SiteManager = SiteManager()
    
    let supportedSiteNames: [String] = ["500px", "AP", "BBCNews", "BBCSport", "Bloomberg", "BusinessInsider", "Buzzfeed", "CNN", "Deviant", "EntertainmentWeekly", "ESPN", "Etsy", "Giphy", "HackerNews", "IGN", "Imgur", "MTV", "NationalGeographic", "Newsweek", "NYmag", "NYTimes", "Reuters", "Soundcloud", "Spotify", "StackOverflow", "Techcrunch", "Time", "USAToday", "Vimeo", "WashPost", "WSJ", "YouTube"]

}
