//
//  ReasoningViewController.swift
//  instapass-guard
//
//  Created by 法好 on 2020/6/28.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class ReasoningViewController: UIViewController {

    var parentVC: ScanViewController?
    var tokenParentVC: ReleaseTokenViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onTextChanged(otherReasonText)
    }
    @IBOutlet weak var okButton: RadiusButton!
    
    @IBAction func onTextChanged(_ sender: UITextField) {
        okButton.isEnabled = (sender.text != nil && sender.text != "")
    }
    
    @IBOutlet weak var otherReasonText: UITextField!
    override func viewDidDisappear(_ animated: Bool) {
        parentVC?.reasoningCallback(reason: "未列明")
        super.viewDidDisappear(animated)
    }
    
    @IBAction func presetReasonTapped(_ sender: UIButton) {
        if parentVC != nil {
            parentVC?.reasoningCallback(reason: sender.currentTitle ?? "未列明")
        } else {
            QRCodeManager.outingReason = sender.currentTitle
            tokenParentVC?.reasoningButton.setTitle(sender.currentTitle ?? "设定事由", for: .normal)
        }
    }
    
    @IBAction func customReasonTapped(_ sender: UIButton) {
        if parentVC != nil {
            parentVC?.reasoningCallback(reason: otherReasonText.text ?? "未列明")
        } else {
            QRCodeManager.outingReason = otherReasonText.text
            tokenParentVC?.reasoningButton.setTitle(sender.currentTitle ?? "设定事由", for: .normal)
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
