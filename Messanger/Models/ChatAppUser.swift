//
//  ChatAppUser.swift
//  Messanger
//
//  Created by RUPALI VERMA on 20/07/24.
//

import Foundation

struct ChatAppUser{
    let emailAddress:String
    let name:String
   // let profileImageURL :String
    
    var safeEmail:String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "#", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "[", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "]", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
