//
//  UserData.swift
//  AppLaunchTask
//
//  Created by Pavan Kumar on 23/03/21.
//

import UIKit

class UserData: NSObject {
    
    var id: Int
    var firstname: String?
    var email: String?
    
    init(id: Int, firstname: String?, email: String?){
        self.id = id
        self.firstname = firstname
        self.email = email
    }
    
}
