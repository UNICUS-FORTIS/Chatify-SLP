//
//  RealmRepository.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/15/24.
//

import Foundation
import RealmSwift

final class RealmRepository {
    
    static let shared = RealmRepository()
    private init() { }
    
    private let realm = try! Realm()
    
    func fetchStoredChatData(workspaceID:Int, channelID: Int) -> Results<Channel>? {
        
        guard let workspace = realm.objects(ChannelChatData.self).first(where: { $0.workspaceID == workspaceID}) else { return nil }
        
        let target = workspace.channelID.filter("id == %@", channelID)
        
        guard !target.isEmpty else { return nil }
        return target
    }
    
    func createNewChannelChat(workspaceID: Int, chatData: ChatModel) {
        
        // MARK: - 새로운 워크스페이스의 채팅인경우
        guard let workspace = realm.objects(ChannelChatData.self).first(where: { $0.workspaceID == workspaceID }) else {
            do { // 새로운 워크스페이스에서 채팅을 보낼경우
                try realm.write {
                    let newWorkspaceData = ChannelChatData(workspaceID: workspaceID,
                                                           chatData: chatData)
                    realm.add(newWorkspaceData)
                    print("새로운 워크스페이스 데이터 생성 완료")
                }
            } catch {
                print("새로운 워크스페이스 데이터 생성 못함")
            }
            return
        }
        
        // MARK: - 채팅에 참여했던 워크스페이스가 존재하지만 해당 채널에 첫 채팅인경우
        guard let existChannel = workspace.channelID.first(where: { $0.id == chatData.channelID }) else {
            let newChat = Channel(data: chatData)
            do {
                try realm.write {
                    workspace.channelID.append(newChat)
                    print("DB에 새로운 신규채널 데이터 입력")
                }
            } catch {
                print(error)
            }
            return
        }
    }

    func updateChannelChatDatabse(workspaceID: Int, channelID: Int, newDatas: [ChannelDataSource]) {
        
        guard let exist = realm.objects(ChannelChatData.self).first(where: {$0.workspaceID == workspaceID}) else { return }
        
        guard let channel = exist.channelID.first(where: { $0.id == channelID }) else { return }
        
        do {
            try realm.write {
                print("새로운 채팅", newDatas)
                channel.chatData.append(objectsIn: newDatas)
                print("새로운 채팅 append 완료")
            }
        } catch {
            print("새로운 채팅 append 실패")
        }
    }
    
    func removeChannelChatting(workspaceID: Int, channelID: Int) {
        guard let exist = realm.objects(ChannelChatData.self).first(where: {$0.workspaceID == workspaceID}) else { return }
        
        guard let channel = exist.channelID.first(where: { $0.id == channelID }) else { return }
        
        do {
            try realm.write {
//                channel.chatData.forEach { realm.delete( $0.user ) }
                realm.delete(channel.chatData)
                realm.delete(channel)
                print("채널 정보 지우기 성공")
            }
        } catch {
            print("채널 정보 지우기 실패")
        }
    }
    
    func checkRealmDirectory() {
        print(#function)
        print(realm.configuration.fileURL!)
    }
}
