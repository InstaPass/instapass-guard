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

    var childVC: QRCodesViewController?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var reasoningButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateNavigationTitle()
        
        reasoningButton.setTitle(QRCodeManager.outingReason ?? "设定事由", for: .normal)
    }
    
    @IBAction func reasoningButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "tokenReasoningSegue", sender: self)
    }
    
    @IBAction func onSelectionChanged(_ sender: UISegmentedControl) {
        releaseTemporaryToken = sender.selectedSegmentIndex == 0
        updateNavigationTitle()
        
        sender.isEnabled = false
        childVC?.scrollToPage(.at(index: sender.selectedSegmentIndex),
                              animated: true, completion: {_,_,_ in 
                                sender.isEnabled = true
                              })
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
        } else if segue.identifier == "tokenReasoningSegue" {
            (segue.destination as? ReasoningViewController)?.tokenParentVC = self
        }
    }
}
