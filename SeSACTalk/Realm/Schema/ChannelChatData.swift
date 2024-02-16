//
//  ChannelChatData.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/15/24.
//

import Foundation
import RealmSwift

final class ChannelChatData: Object {
    
    @Persisted(primaryKey: true) var workspaceID: Int
    @Persisted var channelID = List<Channel>()
    
    convenience init(workspaceID: Int, chatData: ChatModel) {
        self.init()
        self.workspaceID = workspaceID
        
        let data = Channel(data: chatData)
        self.channelID.append(data)
    }
}

final class Channel: Object {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var chatData = List<ChannelDataSource>()

    var parentCategory = LinkingObjects(fromType: ChannelChatData.self, property: "channelID")
    var chatDataArray: [ChannelDataSource] {
        return chatData.map { $0 }
    }

    convenience init(data: ChatModel) {
        self.init()
        let chat = ChannelDataSource(chatData: data)
        self.id = chat.channelID
        self.chatData.append(chat)
    }
    
}

final class ChannelDataSource: Object {
    
    @Persisted(primaryKey: true) var chatID: Int
    @Persisted var channelName: String
    @Persisted var channelID: Int
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var files = List<String>()
    @Persisted var user: ChatUserModel?
    
    var filesArray:[String] {
        return files.map { $0 }
    }
    
    var parentCategory = LinkingObjects(fromType: Channel.self, property: "chatData")
    
    convenience init(chatData: ChatModel) {
        self.init()
        self.chatID = chatData.chatID
        self.channelID = chatData.channelID
        self.channelName = chatData.channelName
        self.content = chatData.content ?? ""
        self.createdAt = chatData.createdAt
        self.files.append(objectsIn: chatData.files ?? [])
        let user = ChatUserModel(userID: chatData.user.userID,
                                 email: chatData.user.email,
                                 nickname: chatData.user.nickname,
                                 profileImage: chatData.user.profileImage)
        self.user = user
    }
}

final class ChatUserModel: Object {
    
    @Persisted var userID: Int
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    var parentCategory = LinkingObjects(fromType: ChannelDataSource.self, property: "user")

    convenience init(userID: Int,
         email: String,
         nickname: String,
         profileImage: String? = nil) {
        self.init()
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}


