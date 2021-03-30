//
//  Themes.swift
//  AppLaunchTask
//
//  Created by Pavan Kumar on 22/03/21.
//

import UIKit

class Themes: NSObject {
    func isValidEmail(emailAddressString:String?) -> Bool {
        guard emailAddressString != nil else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: emailAddressString)
    }
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
