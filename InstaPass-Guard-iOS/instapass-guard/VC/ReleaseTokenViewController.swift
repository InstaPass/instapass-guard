//
//  ReleaseTokenViewController.swift
//  instapass-guard
//
//  Created by 法好 on 2020/6/28.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class ReleaseTokenViewController: UIViewController {
    
    var releaseTemporaryToken = true

    @IBOutlet weak var typeSegmentationControl: UISegmentedControl!
    
    var childVC: QRCodesViewController?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var reasoningButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateNavigationTitle()

        if QRCodeManager.outingReason != nil {
            reasoningButton.setTitle("用于「\(QRCodeManager.outingReason!)」", for: .normal)
        } else {
            reasoningButton.setTitle("设定事由…", for: .normal)
        }
    }
    
    @IBAction func reasoningButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "tokenReasoningSegue", sender: self)
    }
    
    func releaseTokenCallback() {
        childVC?.reloadCards()
        reasoningButton.setTitle(QRCodeManager.outingReason ?? "设定事由", for: .normal)
    }
    
    @IBAction func onSelectionChanged(_ sender: UISegmentedControl) {
        updateIssueLabel()
        sender.isEnabled = false
        childVC?.scrollToPage(.at(index: sender.selectedSegmentIndex),
                              animated: true, completion: {_,_,_ in 
                                sender.isEnabled = true
                              })
    }
    
    func updateIssueLabel() {
        releaseTemporaryToken = typeSegmentationControl.selectedSegmentIndex == 0
        if releaseTemporaryToken {
            UIButton.animate(withDuration: 0.2, animations: {
                self.reasoningButton.alpha = 1
            })
        } else {
            UIButton.animate(withDuration: 0.2, animations: {
                self.reasoningButton.alpha = 0
            })
        }
        updateNavigationTitle()
    }
    
    func updateNavigationTitle() {
        if releaseTemporaryToken {
            navigationTitle.title = "发放临时出入凭证"
        } else {
            navigationTitle.title = "发放常住凭证"
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QRCodeSegue" {
            childVC = segue.destination as? QRCodesViewController
            childVC?.parentVC = self
        } else if segue.identifier == "tokenReasoningSegue" {
            (segue.destination as? ReasoningViewController)?.tokenParentVC = self
        }
    }
}
