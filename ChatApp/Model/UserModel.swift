//
//  User.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/23.
//

import Foundation
import Firebase

class UserModel {

    let email: String
    let username: String
    let createdAt: Timestamp
    let profileImageUrl:String
    var uid: String?

    init(dic: [String: Any]) {

        self.email = dic["email"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
        self.createdAt = dic["createAt"] as? Timestamp ?? Timestamp()
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""

    }


}

