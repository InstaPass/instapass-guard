//
//  Utils.swift
//  instapass-guard
//
//  Created by 法好 on 2020/5/11.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

func dateToString(_ date: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    return formatter.string(from: date)
}

extension UIAlertController {

    private struct ActivityIndicatorData {
        static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }

    func addActivityIndicator() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 40,height: 40)
//        ActivityIndicatorData.activityIndicator.color = UIColor.white
        ActivityIndicatorData.activityIndicator.startAnimating()
        vc.view.addSubview(ActivityIndicatorData.activityIndicator)
        self.setValue(vc, forKey: "contentViewController")
    }

    func dismissActivityIndicator() {
        ActivityIndicatorData.activityIndicator.stopAnimating()
        self.dismiss(animated: false)
    }
}
