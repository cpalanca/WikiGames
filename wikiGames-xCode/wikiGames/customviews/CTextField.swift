//
//  CTextField.swift
//
//  Created by Carlos Palanca on 09/02/2020.
//  Copyright © 2020 Carlos P. All rights reserved.
//

import UIKit
//@IBDesignable
class CTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpField()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setUpField()
    }
    /*
    @IBInspectable var leftImage: UIImage?  {
    set {
        let leftImgView = UIImageView(image: newValue)
        leftImgView.contentMode = .scaleAspectFit
        leftImgView.frame = CGRect(x: frame.height*0.1,
                                   y: frame.height*0.1,
                                   width: frame.height*0.8,
                                   height: frame.height*0.8)
        leftView = leftImgView
        leftViewMode = .always
    }
    
    get {
        if let leftImgView = leftView as?  UIImageView {
            return leftImgView.image
        }
        return nil
        }
    }*/
    
    
    private func setUpField() {
        let myColor = UIColor.white
        tintColor             = .white
        textColor             = .white
        font                  = UIFont(name: Fonts.avenirNextCondensedDemiBold, size: 18)
        backgroundColor       = .clear
        autocorrectionType    = .no
        layer.cornerRadius    = 12
        clipsToBounds         = true
        layer.borderWidth = 1.0
        layer.borderColor = myColor.cgColor
        
        let placeholder       = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont   = UIFont(name: Fonts.avenirNextCondensedDemiBold, size: 18)!
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
             NSAttributedString.Key.font: placeholderFont])
        
        let indentView        = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftView              = indentView
        leftViewMode          = .always
    }
    
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
}
