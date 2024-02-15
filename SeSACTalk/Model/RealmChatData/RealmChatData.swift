//
//  RealmChatData.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/15/24.
//

import Foundation
import RealmSwift

final class ChannelChatData: Object {
    
    @Persisted(primaryKey: true) var workspaceID: Int
    @Persisted var channelData: List<ChannelDataSource>
    
    convenience init(workspaceID: Int, channelData: List<ChannelDataSource>) {
        self.init()
        self.workspaceID = workspaceID
        self.channelData = channelData
    }
}

final class ChannelDataSource: Object {
    
    @Persisted(primaryKey: true) var channelID: Int
    @Persisted var channelName: String
    @Persisted var chatID: Int
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var user: ChatUserModel
    
    var parentCategory = LinkingObjects(fromType: ChannelChatData.self, property: "channelData")
    
    convenience init(channelID: Int,
                     channelName: String,
                     chatID: Int,
                     content: String,
                     createdAt: String,
                     files: List<String>,
                     user: ChatUserModel) {
        self.init()
        self.channelID = channelID
        self.channelName = channelName
        self.chatID = chatID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}

final class ChatUserModel: Object {
    
    @Persisted var userID: Int
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    init(userID: Int,
         email: String,
         nickname: String,
         profileImage: String? = nil) {
        
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}


