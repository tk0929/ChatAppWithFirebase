//
//  Message.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/30.
//

import Foundation
import Firebase

class Message {

    let name: String
    let message: String
    let uid: String
    let createdAt: Timestamp

    var partnerUser: UserModel?

    init(dic: [String: Any]) {

        self.name = dic["name"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()

    }



}
