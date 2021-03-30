//
//  UITextField.swift
//  AppLaunchTask
//
//  Created by Pavan Kumar on 22/03/21.
//

import Foundation
import UIKit

extension UITextField {
  func setBottomBorder() {
    let border = CALayer()
    let width = CGFloat(1.0)
    border.borderColor = UIColor.gray.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + 100, height: self.frame.size.height)
    border.borderWidth = width
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
  }
}
