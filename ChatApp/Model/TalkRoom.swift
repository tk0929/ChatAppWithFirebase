//
//  TalkRoom.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/26.
//

import Foundation
import Firebase


class TalkRoom {

    let latestMessageId: String
    let members: [String]
    let createdAt: Timestamp
    
    var latestMessage: Message?
    var partnerUser: UserModel?
    var docmentId: String?

    init(dic: [String: Any]) {
        
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        
    }
    
    
}
