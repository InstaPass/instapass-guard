//
//  LocationHelper.swift
//  instapass-guard
//
//  Created by 法好 on 2020/6/30.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation
import CoreLocation


class LocationHelper: CLLocationManager, CLLocationManagerDelegate {
    
    private var successBlock: ((_ position: CLLocationCoordinate2D) -> Void)?
    private var failureBlock: ((_ error: String) -> Void)?

    init(desiredAccuracy accuracy: CLLocationAccuracy = kCLLocationAccuracyBest) {
        super.init()
        delegate = self
        desiredAccuracy = accuracy
    }
    
    convenience init(success: ((CLLocationCoordinate2D) -> Void)?, failure: ((String) -> Void)?, desiredAccuracy accuracy: CLLocationAccuracy = kCLLocationAccuracyBest) {
        self.init(desiredAccuracy: accuracy)
        getLocation(success: success, failure: failure)
    }
    
    func getLocation(success: ((CLLocationCoordinate2D) -> Void)?, failure: ((String) -> Void)?) {
        successBlock = success
        failureBlock = failure
        requestWhenInUseAuthorization()
        startUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            stopUpdatingLocation()
            successBlock?(location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.stopUpdatingLocation()
        var errorMsg = "未知错误"
        switch (error as NSError).code {
        case 0:
            errorMsg = "位置不可用"
            break
        case 1:
            errorMsg = "未授予权限"
            break
        default: break
        }
        failureBlock?(errorMsg)
    }
}
