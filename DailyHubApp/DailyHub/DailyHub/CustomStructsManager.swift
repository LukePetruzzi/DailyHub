//
//  SitePrefManager.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/27/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation

struct SitePref: JSONSerializable {
    var siteName:String
    var numPosts:Int
}

struct FavoritedPost: JSONSerializable {
    var dateTimeAdded:String
    var siteName:String
    var title:String?
    var author:String?
    var url:String?
    var thumbnail:String?
    var description:String?
}

struct ContentInfo: JSONSerializable {
    var title:String?
    var author:String?
    var url:String?
    var thumbnail:String?
    var description:String?
}

// all this json representable protocol stuff I created by reference from here: 
// http://codelle.com/blog/2016/5/an-easy-way-to-convert-swift-structs-to-json/

protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol JSONSerializable: JSONRepresentable {
}

extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation
                
            case let value as NSObject:
                representation[label] = value
                
            default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation as AnyObject
    }
}

extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
}







