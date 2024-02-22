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
    var userID: Int?
    
    func createInitialUserdata() {
        guard let _ = realm.objects(UserData.self).first(where: { $0.userID == self.userID}) else {
            do {
                try realm.write {
                    guard let safeID = self.userID else { return }
                    let newUserdata = UserData(userID: safeID)
                    realm.add(newUserdata)
                    print("새로운 유저데이터 생성 완료")
                }
            } catch {
                print("새로운 유저데이터 생성 실패")
            }
            return
        }
        print("아무것도 생성하지 않았음")
    }
    
    func createInitialWorkspaceData(new: WorkSpaces) {
        guard let userID = realm.objects(UserData.self).first(where: { $0.userID == self.userID}) else { return }
        let workspacesArray = new.map { $0 }
        
        if userID.workspaceList.isEmpty {
            do {
                try realm.write {
                    let newWorkspaceList = workspacesArray.map { WorkspaceListData(workspaceID: $0.workspaceID,
                                                                                workspaceName: $0.name ) }
                    userID.workspaceList.append(objectsIn: newWorkspaceList)
                    
                }
            } catch {
                print("초기 데이터 작성 실패")
            }
            print("초기 데이터 작성 완료")
        } else {
            let filtered = workspacesArray.filter { workspace in
                !userID.workspaceList.contains(where: { $0.workspaceID == workspace.workspaceID })
            }
            do {
                try realm.write {
                    let newDatas = filtered.map { WorkspaceListData(workspaceID: $0.workspaceID,
                                                                    workspaceName: $0.name) }
                    userID.workspaceList.append(objectsIn: newDatas)
                }
            } catch {
                print("신규 워크스페이스 작성 실패")
            }
            print("신규 워크스페이스 작성 완료", filtered)
        }
    }
    
    func createInitialChannelList(targetWorkspaceID: Int, channelID: Int) {
        print(#function)
        guard let userID = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
        let workspaceList = userID.workspaceList.first(where: { $0.workspaceID == targetWorkspaceID}) else { return }
        let newChannel = Channel(channelID: channelID)
        
        if workspaceList.channelList.isEmpty {
            do {
                try realm.write {
                    workspaceList.channelList.append(newChannel)
                }
            } catch {
                print("신규 채널 작성 실패")
            }
            print("신규 채널 작성 성공---------@@@")
        } else {
            if !workspaceList.channelList.contains(where: { $0.id == channelID }) {
                do {
                    try realm.write {
                        workspaceList.channelList.append(newChannel)
                    }
                } catch {
                    print("필터링된 채널 append 실패")
                }
                print("신규 채널 append 성공", newChannel)

            } else {
                print("채널 필터링 안하고 아무동작 안함")
            }
            print("아무 신규 채널 append 하지 않았음")
        }
    }
    
    func fetchStoredChatData(workspaceID:Int, channelID: Int) -> Results<Channel>? {
        print("저장된 채팅 로드", self.userID ?? 00000000)
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == workspaceID }) else { return nil }
        
        let target = workspace.channelList.filter("id == %@", channelID)
        
        guard !target.isEmpty else { return nil }
        return target
    }
    
    func createNewChannelChat(workspaceID: Int, chatData: ChatModel) {
        
        // MARK: - 새로운 워크스페이스의 채팅인경우
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == workspaceID }) else {
            do { // 새로운 워크스페이스에서 채팅을 보낼경우
                try realm.write {
                    let newWorkspaceData = Channel(data: chatData)
                    realm.add(newWorkspaceData)
                    print("새로운 워크스페이스 데이터 생성 완료")
                }
            } catch {
                print("새로운 워크스페이스 데이터 생성 못함")
            }
            return
        }
        
        // MARK: - 채팅에 참여했던 워크스페이스가 존재하지만 해당 채널에 첫 채팅인경우
        guard let _ = workspace.channelList.first(where: { $0.id == chatData.channelID }) else {
            let newChat = Channel(data: chatData)
            do {
                try realm.write {
                    workspace.channelList.append(newChat)
                    print("DB에 새로운 신규채널 데이터 입력")
                }
            } catch {
                print(error)
            }
            return
        }
    }
    
    func updateChannelChatDatabse(workspaceID: Int, channelID: Int, newDatas: [ChannelDataSource]) {
        
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == workspaceID }),
              let channel = workspace.channelList.first(where: { $0.id == channelID }) else { return }
        
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
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == workspaceID }) else {
            return }
        
        guard let channel = workspace.channelList.first(where: { $0.id == channelID }) else { return }
        
        do {
            try realm.write {
                channel.chatData.forEach {
                    if let user = $0.user {
                        realm.delete(user)
                    }
                }
                realm.delete(channel.chatData)
                realm.delete(channel)
                print("채널 정보 지우기 성공")
            }
        } catch {
            print("채널 정보 지우기 실패")
        }
    }
    
    func getChannelLatestChatDate(workspaceID: Int, channelID: Int) -> String? {
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == workspaceID }) else {
            return nil }
        
        guard let channel = workspace.channelList.first(where: { $0.id == channelID }) else { return nil }
        
        return channel.chatData.last?.createdAt
    }
    
    func checkRealmDirectory() {
        print(#function)
        print(realm.configuration.fileURL!)
    }
}
