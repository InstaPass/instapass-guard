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
        LoginHelper.logout(handler: { _ in
            // handle logout stuff
        })
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 2 {
            if indexPath.row == 0 {
                // switch user
                switchUser()
            } else if indexPath.section == 1 {
                // quit
                LoginHelper.logout(handler: {_ in
                    // flush personal info
                })
            }
        }
    }

}
