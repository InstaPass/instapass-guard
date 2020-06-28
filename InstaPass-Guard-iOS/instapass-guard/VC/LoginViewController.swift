//
//  LoginViewController.swift
//  instapass-guard
//
//  Created by 法好 on 2020/5/11.
//  Copyright © 2020 yuetsin. All rights reserved.
//
import UIKit
import SPAlert
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passWordTextField: UITextField!
    
    @IBOutlet weak var loginImageView: UIImageView!
    
    var parentVC: UserTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        userNameTextField.delegate = self
        passWordTextField.delegate = self
        
        loginImageView.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(loginButtonTapped))
        loginImageView.addGestureRecognizer(singleTap)
        
        userNameTextField.text = UserPrefInitializer.userName
        passWordTextField.text = UserPrefInitializer.passWord
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.placeholder = nil
//    }
//
//    let placeHolderString = ["用户名", "密码"]
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.placeholder = placeHolderString[textField.tag]
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passWordTextField.becomeFirstResponder()
        } else if textField == passWordTextField {
            passWordTextField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }

    @objc func loginButtonTapped() {
        let userName = self.userNameTextField.text ?? ""
        let passWord = self.passWordTextField.text ?? ""
        displayActivityIndicatorAlert(title: "登录中…", message: nil, handler: {
            
            let loginParams: Parameters = [
                "username": userName,
                "password": passWord,
            ]
            RequestManager.request(type: .post,
                                   feature: .login,
                                   subUrl: nil,
                                   params: loginParams,
                                   success: { jsonResp in
                                      UserPrefInitializer.userName = userName
                                      UserPrefInitializer.passWord = passWord
                                      var communities: [Community] = []
                                    NSLog(jsonResp.stringValue)
                                    
                                    for commObject in jsonResp["working_communities"].arrayValue {
                                        communities.append(Community(id: commObject["community_id"].intValue,
                                                                     name: commObject["community"].stringValue, address: commObject["address"].stringValue))
                                    }
                                    self.dismissActivityIndicatorAlert(handler: {
                                        self.chooseWorkingCommunity(communities: communities)
                                    })
                                   }, failure: { error in
                                    DispatchQueue.main.async {
                                        self.dismissActivityIndicatorAlert(handler: {
                                            SPAlert.present(title: "登录失败", image: UIImage(systemName: "multiply")!)
                                        })
                                    }
            })
        })
    }
    
    func chooseWorkingCommunity(communities: [Community]) {
        let alertController = UIAlertController(title: "请确认您的工作单位。",
                                                message: "这将影响出入凭证发放功能，请正确选择。",
                                                preferredStyle: .actionSheet)
        
        alertController.view.setTintColor()
        
        for community in communities {
            let communitySelection = UIAlertAction(title: community.name,
                                                   style: .default,
                                                   handler: { _ in
                                                        Community.activeCommunity = community
                                                        self.performSegue(withIdentifier: "loginDoneSegue", sender: nil)
                                                    })
            alertController.addAction(communitySelection)
        }
        
        if communities.count == 0 {
            let fallbackAction = UIAlertAction(title: "无任职中的小区",
                                                   style: .default,
                                                   handler: nil)
            fallbackAction.isEnabled = false
            alertController.addAction(fallbackAction)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    var activityIndicatorAlert: UIAlertController?

    func displayActivityIndicatorAlert(title: String, message: String?, handler: (() -> Void)?) {
        activityIndicatorAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        activityIndicatorAlert!.addActivityIndicator()
        present(activityIndicatorAlert!, animated: true, completion: handler)
    }

    func dismissActivityIndicatorAlert(handler: (() -> Void)?) {
        activityIndicatorAlert?.dismiss(animated: true, completion: handler)
        activityIndicatorAlert = nil
    }
}
