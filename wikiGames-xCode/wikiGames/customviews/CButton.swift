//
//  CButton.swift
//  ADDING SUPPORT CORNER RADIUS TO THE INSPECTOR
//
//  Created by Carlos Palanca on 09/02/2020.
//  Copyright © 2020 Carlos P. All rights reserved.
//

import UIKit
@IBDesignable
class CButton: UIButton {

        @IBInspectable var borderWidth: CGFloat {
            set {
                layer.borderWidth = newValue
            }
            get {
                return layer.borderWidth
            }
        }

        @IBInspectable var cornerRadius: CGFloat {
            set {
                layer.cornerRadius = newValue
            }
            get {
                return layer.cornerRadius
            }
        }

        @IBInspectable var borderColor: UIColor? {
            set {
                guard let uiColor = newValue else { return }
                layer.borderColor = uiColor.cgColor
            }
            get {
                guard let color = layer.borderColor else { return nil }
                return UIColor(cgColor: color)
            }
        }
}
