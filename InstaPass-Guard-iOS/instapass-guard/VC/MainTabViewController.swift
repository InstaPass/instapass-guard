//
//  MainTabBarController.swift
//  instapass-guard
//
//  Created by 法好 on 2020/6/28.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit


class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return FadeAnimator(duration: 0.2)
        }
}
