//
//  ChatProtocol.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/17/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatProtocol: AnyObject {
    
    var channelChatRelay: BehaviorRelay<[ChannelDataSource]> { get set }
    var dmChatRelay: BehaviorRelay<[String]> { get set }
    var channelInfo: Channels? { get }
    var dmID: Int? { get }
    var roomdID: Int? { get }
    
    func createSocketURL() -> String
    func messageSender<T>(request: T)
    func createSocketNamespace() -> String
    func loadRecentChatFromDatabse()
    func getCursorDate(channelInfo: Channels) -> String
    func getCurrentTimeForCursor() -> String
    func judgeSender(sender: Int, userID: Int) -> Bool
    func loadChatLog(completion: @escaping () -> Void )
    func createChannelID() -> Int?
    func checkRelayIsEmpty() -> Bool
    func connectSocket()
    func disconnectSocket()
}

extension ChatProtocol {
    
    func getCurrentTimeForCursor() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let now = Date()
        print(formatter.string(from: now))
        return formatter.string(from: now)
    }
    
    func judgeSender(sender: Int, userID: Int) -> Bool {
        return sender == userID ? true : false
    }
    
    func createChannelID() -> Int? {
        guard let safe = channelInfo else { return nil }
        return safe.channelID
    }
}
