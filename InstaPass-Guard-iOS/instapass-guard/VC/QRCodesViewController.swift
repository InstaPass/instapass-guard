//
//  QRCodesViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/22.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import Pageboy
import SPAlert

class QRCodesViewController: PageboyViewController, PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    
    var parentVC: ReleaseTokenViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCommunities()
        delegate = self
        dataSource = self
    }
    
    func reloadCards() {
        if viewControllers.count > 0 {
            (viewControllers[0] as? QRCodeChildPageViewController)?.refreshQRCode()
        }
    }

    var viewControllers: [UIViewController] = []
    
    func refreshCommunities() {
        viewControllers.removeAll()
        

        let tempViewController = self.storyboard?.instantiateViewController(withIdentifier: "QrCodeChildVC") as! QRCodeChildPageViewController
        tempViewController.temporary = true
        
        let constantViewController = self.storyboard?.instantiateViewController(withIdentifier: "QrCodeChildVC") as! QRCodeChildPageViewController
        constantViewController.temporary = false
        
        self.viewControllers.append(tempViewController)
        self.viewControllers.append(constantViewController)
        self.reloadData()
    }


    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
//        pgDelegate?.setNumberOfPages(number: viewControllers.count)
        return viewControllers.count
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: NavigationDirection,
                               animated: Bool) {
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {

    }
    
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        if index == 0 {
            parentVC?.typeSegmentationControl.selectedSegmentIndex = 0
        } else {
            parentVC?.typeSegmentationControl.selectedSegmentIndex = 1
            if viewControllers.count > 1 {
                (viewControllers[1] as? QRCodeChildPageViewController)?.showPrompt()
            }
        }
        
        parentVC?.updateIssueLabel()
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didCancelScrollToPageAt index: PageboyViewController.PageIndex, returnToPageAt previousIndex: PageboyViewController.PageIndex) {
//        pgDelegate?.setCurrentPage(current: previousIndex)
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
}


