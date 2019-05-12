//
//  IBExtensions.swift
//  Sunrise-Sunset
//
//  Created by Alex Kagarov on 5/12/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
