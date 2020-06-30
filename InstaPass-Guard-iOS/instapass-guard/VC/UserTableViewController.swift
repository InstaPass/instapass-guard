//
//  UserTableViewController.swift
//  instapass-guard
//
//  Created by 法好 on 2020/5/11.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import SPAlert

class UserTableViewController: UITableViewController {
    
    var locationHelper: LocationHelper?
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
            if Community.activeCommunity == nil {
                SPAlert.present(message: "没有选择任何小区。请重新登录。", haptic: .error)
                return
            }
            if indexPath.row == 0 {
                locationHelper = LocationHelper(success: { location in
                    RequestManager.request(type: .post,
                                           feature: .checkin,
                                           subUrl: nil,
                                           params: [
                                            "community_id": Community.activeCommunity!.id,
                                            "community": Community.activeCommunity!.name,
                                            "address": Community.activeCommunity!.address,
                                            "longitude": location.longitude,
                                            "latitude": location.latitude
                                           ],
                                           success: { _ in
                                            SPAlert.present(title: "已成功打卡上班。", image: UIImage(systemName: "checkmark")!)
                                           }) { error in
                        SPAlert.present(title: "未能成功打卡，因为「\(error)」。", image: UIImage(systemName: "multiply")!)
                    }
                }, failure: { error in
                    SPAlert.present(title: "未能获取位置信息，请再试一次。", image: UIImage(systemName: "multiply")!)
                })
            } else if indexPath.row == 1 {
                locationHelper = LocationHelper(success: { location in
                    RequestManager.request(type: .post,
                                           feature: .checkout,
                                           subUrl: nil,
                                           params: [
                                            "community_id": Community.activeCommunity!.id,
                                            "community": Community.activeCommunity!.name,
                                            "address": Community.activeCommunity!.address,
                                            "longitude": location.longitude,
                                            "latitude": location.latitude
                                           ],
                                           success: { _ in
                                            SPAlert.present(title: "已成功打卡下班。", image: UIImage(systemName: "checkmark")!)
                                           }) { error in
                        SPAlert.present(title: "未能成功打卡，因为「\(error)」。", image: UIImage(systemName: "multiply")!)
                    }
                }, failure: { error in
                    SPAlert.present(title: "未能获取位置信息，请再试一次。", image: UIImage(systemName: "multiply")!)
                })
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
