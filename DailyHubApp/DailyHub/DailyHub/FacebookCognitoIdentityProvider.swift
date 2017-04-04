//
//  FacebookCognitoIdentityProvider.swift
//  DailyHub
//
//  Created by Luke Petruzzi on 4/3/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import Foundation
import AWSCognito
import FBSDKLoginKit


class FacebookCognitoIdentityProvider: NSObject, AWSIdentityProviderManager {
    
    var tokens: String?
    
    init(tokens:String)
    {
        self.tokens = tokens
    }
    
    func logins() -> AWSTask<NSDictionary> {
        return AWSTask(result: [AWSIdentityProviderFacebook:tokens!])
    }
}
