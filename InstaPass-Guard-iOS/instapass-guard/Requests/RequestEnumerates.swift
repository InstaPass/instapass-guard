//
//  RequestEnumerates.swift
//  InstaPass
//
//  Created by 法好 on 2020/5/10.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

enum RequestType {
    case get
    case post
}

enum RequestResponse {
    case ok
    case noResponse
    case internalError
    case unauthorized
}

enum FeatureType: String {
    // TODO: separate user login and guard login
    case login = "/login"
    case validate = "/guard/validate"
}

