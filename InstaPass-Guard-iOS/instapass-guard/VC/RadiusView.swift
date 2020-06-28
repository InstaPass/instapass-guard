//
//  RadiusView.swift
//  instapass-guard
//
//  Created by 法好 on 2020/6/28.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class RadiusButton: UIButton {

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 5
        clipsToBounds = true
        super.draw(rect)
    }

}
