//
//  DesignableView.swift
//  I’M After
//
//  Created by MAC on 11/6/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {
    @IBInspectable var CornerRadius :CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = CornerRadius
        }
    }
    @IBInspectable var BorderWidth :CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = BorderWidth
        }
    }
    @IBInspectable var BorderColor :UIColor = .clear {
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}

@IBDesignable class DesignableLable: UILabel {
    @IBInspectable var CornerRadius :CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = CornerRadius
        }
    }
    @IBInspectable var BorderWidth :CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = BorderWidth
        }
    }
    @IBInspectable var BorderColor :UIColor = .clear {
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}

@IBDesignable class DesignableText: UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}

@IBDesignable class DesignableButton: UIButton {
    @IBInspectable var CornerRadius :CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = CornerRadius
        }
    }
    @IBInspectable var BorderWidth :CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = BorderWidth
        }
    }
    @IBInspectable var BorderColor :UIColor = .clear {
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}

@IBDesignable class DesignableImage: UIImageView {
    @IBInspectable var CornerRadius :CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = CornerRadius
        }
    }
    @IBInspectable var BorderWidth :CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = BorderWidth
        }
    }
    @IBInspectable var BorderColor :UIColor = .clear {
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}


