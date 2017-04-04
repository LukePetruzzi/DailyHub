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
    func logins() -> AWSTask<NSDictionary> {
        if let token = FBSDKAccessToken.current().tokenString {
            return AWSTask(result: [AWSIdentityProviderFacebook:token])
        }
        return AWSTask(error:NSError(domain: "Facebook Login", code: -1 , userInfo: ["Facebook" : "NO CURRENT FACEBOOK ACCESS TOKEN"]))
    }
}
