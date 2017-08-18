//
//  User.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 27/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation

class User {
    
    var uuid: String!
    
    
    var wakeupTime: Date?
    var sleepTime: Date?
    

    var medicineArray: [Medicine]?
    
    //a singleton that can be acessed through out the whole app
    private static var userSingleton: User?
    
    init(uuid: String) {
        self.uuid = uuid
    }
    
    //set the singleton
    static func setSingleton(_ user: User) {
        userSingleton = user
    }

    static var current: User {
        
        guard let currentUser = userSingleton else {
            fatalError("Error: current user doesn't existed")
        }
        
        return currentUser
    }
    
    
}
