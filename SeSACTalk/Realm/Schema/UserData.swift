//
//  ChannelChatData.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/15/24.
//

import Foundation
import RealmSwift

final class UserData: Object {
    
    @Persisted(primaryKey: true) var userID: Int
    @Persisted var workspaceList = List<WorkspaceListData>()
    
    convenience init(userID: Int ) {
        self.init()
        self.userID = userID
    }
}

final class WorkspaceListData: Object {
    
    @Persisted var workspaceID: Int
    @Persisted var workspaceName: String
    @Persisted var channelList = List<Channel>()
    @Persisted var dmList = List<DM>()
    
    convenience init(workspaceID: Int, workspaceName: String) {
        self.init()
        self.workspaceID = workspaceID
        self.workspaceName = workspaceName
    }
}

final class Channel: Object {
    
    @Persisted var id: Int
    @Persisted var chatData = List<ChannelDataSource>()
    @Persisted var channelDatabaseCreatedAt: String

    var chatDataArray: [ChannelDataSource] {
        return chatData.map { $0 }
    }
    
    var latestChat: String? {
        guard let lastCreatedAt = chatData.last else { return nil }
        return lastCreatedAt.createdAt
    }
    
    convenience init(channelID: Int) {
        self.init()
        self.id = channelID
        self.channelDatabaseCreatedAt = getCurrentTimeForCursor()
    }

    convenience init(data: ChatModel) {
        self.init()
        let chat = ChannelDataSource(chatData: data)
        self.id = chat.channelID
        self.chatData.append(chat)
        self.channelDatabaseCreatedAt = getCurrentTimeForCursor()
    }
    
    func getCurrentTimeForCursor() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let now = Date()
        print(formatter.string(from: now))
        return formatter.string(from: now)
    }
}

final class ChannelDataSource: Object {
    
    @Persisted var chatID: Int
    @Persisted var channelName: String
    @Persisted var channelID: Int
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var files = List<String>()
    @Persisted var user: ChatUserModel?
    
    var filesArray:[String] {
        return files.map { $0 }
    }
        
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

final class DM: Object {
    
    @Persisted var workspacdID: Int
    @Persisted var roomID: Int
    @Persisted var dmData = List<DMDataSource>()
    @Persisted var DMDatabaseCreatedAt: String
    
    var dmDataArray: [DMDataSource] {
        return dmData.map { $0 }
    }
    
    var latestChat: String? {
        guard let lastCreatedAt = dmData.last else { return nil }
        return lastCreatedAt.createdAt
    }

    convenience init(dm: DMChatResponse) {
        self.init()
        self.workspacdID = dm.workspaceID
        self.roomID = dm.roomID
        self.DMDatabaseCreatedAt = getCurrentTimeForCursor()
    }
    
    func getCurrentTimeForCursor() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let now = Date()
        print(formatter.string(from: now))
        return formatter.string(from: now)
    }
}

final class DMDataSource: Object {
    
    @Persisted var dmID: Int
    @Persisted var content: String?
    @Persisted var files = List<String>()
    @Persisted var createdAt: String
    @Persisted var user: ChatUserModel?
    
    convenience init(dm: DMChatModel) {
        self.init()
        self.dmID = dm.dmID
        self.content = dm.content ?? ""
        self.createdAt = dm.createdAt
        self.files.append(objectsIn: dm.files ?? [])
        let user = ChatUserModel(userID: dm.user.userID,
                                 email: dm.user.email,
                                 nickname: dm.user.nickname,
                                 profileImage: dm.user.profileImage)
        self.user = user
    }
}
