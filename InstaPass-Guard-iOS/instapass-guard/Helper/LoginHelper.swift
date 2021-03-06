//
//  LoginHelper.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/25.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Alamofire
import Alamofire_SwiftyJSON
import Foundation
import SwiftyJSON

class LoginHelper {
    // always assume login until one request gets unauthorized
    static var isLogin: Bool = true

    static func login(username: String, password: String, handler: @escaping (RequestResponse) -> Void) {
        let loginParams: Parameters = [
            "username": username,
            "password": password,
        ]
        RequestManager.request(type: .post,
                               feature: .login,
                               subUrl: nil,
                               params: loginParams,
                               success: { jsonResp in
                                   UserPrefInitializer.jwtToken = jsonResp["jwt_token"].stringValue
                                   handler(.ok)
                               }, failure: { _ in
                                   handler(.unauthorized)
        })
    }

    static func logout(handler: (RequestResponse) -> Void) {
        isLogin = false
        UserPrefInitializer.jwtToken = ""
        handler(.ok)
    }
}
