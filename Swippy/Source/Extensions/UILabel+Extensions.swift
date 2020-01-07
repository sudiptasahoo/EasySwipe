//
//  UILabel+Extensions.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 07/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func addSignatureShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.masksToBounds = false
    }
}
