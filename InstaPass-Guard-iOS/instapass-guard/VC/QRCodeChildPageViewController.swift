//
//  QRCodeChildPageViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/22.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import SPAlert

class QRCodeChildPageViewController: UIViewController {
    
    @IBOutlet var cardView: UIVisualEffectView!
    @IBOutlet var QRCodeView: UIImageView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var lastUpdateTextField: UILabel!
    
    var temporary: Bool = true
//    var reason: String?
    
    var parentVC: ReleaseTokenViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        redrawPageShadow()
    }
    
    func redrawPageShadow() {
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.label.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 20
        cardView.layer.shadowOpacity = 0.22
//        cardView.clipsToBounds = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        redrawPageShadow()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        refreshQRCode()
    }
    
    var secret: String?

    func flushQRCode() {
        //        let style = traitCollection.userInterfaceStyle

        QRCodeView.image = QRCodeManager.getQRCodeImage(secret: secret)

        if QRCodeView.image == nil {
            QRCodeView.image = UIImage(systemName: "multiply")
        }
    }

    @IBAction func onRefreshButtonTapped(_ sender: UIButton) {
        refreshQRCode()
    }

    
//    var canRefresh: Bool = true

    func refreshQRCode() {
        if !self.refreshButton.isEnabled {
            return
        }

        refreshButton.isEnabled = false
        QRCodeManager.refreshQrCode(temporary: temporary,
                                    reason: QRCodeManager.outingReason,
                                    success: { secret, time in
            self.secret = secret
            self.flushQRCode()
            self.lastUpdateTextField.text = "已于 \(dateToString(time, dateFormat: "HH:mm")) 更新"
            self.refreshButton.isEnabled = true
        }, failure: { error in
            // show ${error} message
            self.flushQRCode()
            self.lastUpdateTextField.text = "请求失败"
            SPAlert.present(title: "请求 QR 码失败", message: error, image: UIImage(systemName: "wifi.exclamationmark")!)
            self.refreshButton.isEnabled = true
        })
    }
}

