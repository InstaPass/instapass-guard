//
//  ReasoningViewController.swift
//  instapass-guard
//
//  Created by 法好 on 2020/6/28.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class ReasoningViewController: UIViewController, UITextFieldDelegate {

    var parentVC: ScanViewController?
    var tokenParentVC: ReleaseTokenViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        onTextChanged(otherReasonText)
        otherReasonText.delegate = self
        
        navigationItem.backBarButtonItem?.tintColor = globalTintColor
        
        if parentVC != nil {
            navigationItem.backButtonTitle = "验证出入凭证"
        } else if tokenParentVC != nil {
            navigationItem.backButtonTitle = "发放临时出入凭证"
        } else {
            navigationItem.backButtonTitle = "返回"
        }
    }
    
    @IBOutlet weak var okButton: RadiusButton!
    
    @IBAction func onTextChanged(_ sender: UITextField) {
        if sender.text == nil || sender.text == "" {
            okButton.isEnabled = false
        } else {
            okButton.isEnabled = true
        }
    }
    
    var tapped: Bool = false
    @IBOutlet weak var otherReasonText: UITextField!
    override func viewDidDisappear(_ animated: Bool) {
        if !tapped {
            parentVC?.reasoningCallback(reason: "未列明")
        }
        super.viewDidDisappear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == otherReasonText {
            customReasonTapped(okButton)
        }
        return true
    }
    
    @IBAction func presetReasonTapped(_ sender: UIButton) {
        tapped = true
        navigationController?.popViewController(animated: true)
        if parentVC != nil {
            parentVC?.reasoningCallback(reason: sender.currentTitle ?? "未列明")
        } else {
            QRCodeManager.outingReason = sender.currentTitle
            tokenParentVC?.releaseTokenCallback()
        }
    }
    
    @IBAction func customReasonTapped(_ sender: UIButton) {
        tapped = true
        navigationController?.popViewController(animated: true)
        if parentVC != nil {
            parentVC?.reasoningCallback(reason: otherReasonText.text ?? "未列明")
        } else {
            QRCodeManager.outingReason = otherReasonText.text
            tokenParentVC?.releaseTokenCallback()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
