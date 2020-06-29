//
//  UserTableViewController.swift
//  instapass-guard
//
//  Created by 法好 on 2020/5/11.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit


class UserTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func switchUser() {
        let alertController = UIAlertController(title: "真的要注销登录吗？",
                                                message: "您将需要重新提供身份证明来再次登录。",
                                                preferredStyle: .actionSheet)
        
        alertController.view.setTintColor()
        
        let leaveAction = UIAlertAction(title: "注销",
                                        style: .destructive,
                                        handler: { _ in
                                            LoginHelper.logout(handler: { _ in
                                                // handle logout stuff
                                            })
                                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                                         })
        let cancelAction = UIAlertAction(title: "取消",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(leaveAction)
        alertController.addAction(cancelAction)
        
        let targetCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1))
        alertController.popoverPresentationController?.sourceView = targetCell
        alertController.popoverPresentationController?.sourceRect = targetCell?.bounds ?? CGRect.zero
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            if indexPath.row == 0 {
//                RequestManager.request(type: .post,
//                                       feature: <#T##FeatureType#>,
//                                       subUrl: <#T##[String]?#>,
//                                       params: <#T##Parameters?#>,
//                                       success: <#T##(JSON) -> Void#>,
//                                       failure: <#T##(String) -> Void#>)
            } else if indexPath.row == 1 {
                // check-out
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                // preference
            } else if indexPath.section == 1 {
                // quit
                switchUser()
            }
        }
    }

}
