//
//  ScanViewController.swift
//  instapass-guard
//
//  Created by 法好 on 2020/4/24.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import AVFoundation
import QRCodeReader
import UIKit
import SPAlert

class ScanViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)

            // Configure the view controller (optional)
            $0.showTorchButton = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton = true
            $0.showOverlayView = true
//            $0.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }

        return QRCodeReaderViewController(builder: builder)
    }()

    @IBAction func startScan(_ sender: UIButton) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self

        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if result == nil {
                return
            }
            print("scan qrcode content: \(result!.value)")
            
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "Scan Result", message: String(describing: result), preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                alert.addAction(UIAlertAction(title: "Copy", style: .cancel, handler: nil))
//
//                self.present(alert, animated: true)
//            }
            let secretValue = result!.value
            if secretValue.hasPrefix("instapass{") && secretValue.hasSuffix("}") {
                RequestManager.request(type: .post,
                                       feature: .validate,
                                       subUrl: nil,
                                       params: [
                                        "secret": secretValue,
                                        "reason": "TODO: 这里还没写"
                ], success: { jsonResponse in
                    DispatchQueue.main.async {
                        SPAlert.present(title: "请求成功", message: "此出入申请已被批准。服务器说「\(jsonResponse["validation"].stringValue)」。", image: UIImage(systemName: "checkmark.shield")!)
                    }
                }, failure: { errorMsg in
                    SPAlert.present(title: "请求失败", message: "此出入申请未被批准。服务器报告了一个「 \(errorMsg)」错误。", image: UIImage(systemName: "multiply")!)
                })
            } else {
                SPAlert.present(title: "扫描 QR 码失败", message: "这不是一个合法的 InstaPass QR 码。", image: UIImage(systemName: "multiply")!)
            }
        }

        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet

        present(readerVC, animated: true, completion: nil)
    }

    // MARK: - QRCodeReaderViewController Delegate Methods

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
}
