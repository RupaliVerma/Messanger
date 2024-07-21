//
//  DataBaseManager.swift
//  Messanger
//
//  Created by RUPALI VERMA on 20/07/24.
//

import Foundation
import FirebaseDatabase

class DataBaseManager{
    
    static let shared = DataBaseManager()
    
    private let database = Database.database().reference()
    
    
}

//MARK: - Account Management

extension DataBaseManager {
    
    
    public func validateNewUser(with email:String,
                                completion:@escaping (Bool) -> ()){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "#", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "[", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "]", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func insertUser(with user :ChatAppUser){
        
        database.child(user.safeEmail).setValue(["name":user.name])
    }
    
    
}
