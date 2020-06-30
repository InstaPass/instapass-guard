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
    
    @IBOutlet weak var previousQRCodeView: UIImageView!
    @IBOutlet var cardView: UIVisualEffectView!
    @IBOutlet var QRCodeView: UIImageView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var lastUpdateTextField: UILabel!
    
    var temporary: Bool = true
    var secret: String?
//    var reason: String?
    var timer: Timer?
    var alreadyPrompted = false
    
    var parentVC: ReleaseTokenViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        redrawPageShadow()
        QRCodeView.image = UIImage(systemName: "qrcode")
        
        timer = Timer(timeInterval: 10, target: self, selector: #selector(refreshQRCode), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.default)
    }
    
    func showPrompt() {
        if !alreadyPrompted {
            if !temporary {
                let alertController = UIAlertController(title: "警告", message: "发放常住出入凭证前，请务必确认住户身份。", preferredStyle: .alert)
                alertController.view.setTintColor()
                alertController.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            alreadyPrompted = true
        }
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

    func flushQRCode() {
        //        let style = traitCollection.userInterfaceStyle

        previousQRCodeView.image = QRCodeView.image
        QRCodeView.image = QRCodeManager.getQRCodeImage(secret: secret)
        
        if QRCodeView.image == nil {
            QRCodeView.image = UIImage(systemName: "qrcode")
        }
        
        previousQRCodeView.alpha = 1
        QRCodeView.alpha = 0

        UIView.animate(withDuration: 0.1, animations: {
            self.previousQRCodeView.alpha = 0
            self.QRCodeView.alpha = 1
        })
    }

    @IBAction func onRefreshButtonTapped(_ sender: UIButton) {
        refreshQRCode()
    }

    
//    var canRefresh: Bool = true

    @objc func refreshQRCode() {
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
            self.secret = nil
            self.flushQRCode()
            self.lastUpdateTextField.text = "请求失败：\(error)"
//            SPAlert.present(title: "请求 QR 码失败", message: error, image: UIImage(systemName: "wifi.exclamationmark")!)
            self.refreshButton.isEnabled = true
        })
    }
}

