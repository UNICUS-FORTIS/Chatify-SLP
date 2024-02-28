//
//  DMRealmRepository.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/27/24.
//

import Foundation
import RealmSwift


final class DMRealmRepository {
    
    static let shared = DMRealmRepository()
    private init() { }
    
    private let realm = try! Realm()
    var userID: Int?
    
    func fetchDMDatas(dmRoomID: Int, workspaceID: Int) -> Results<DM>? {
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == workspaceID}) else { return nil }
        
        let target = workspace.dmList.filter("roomID == %@", dmRoomID)
        guard !target.isEmpty else { return nil }
        print("DM 데이터 불러왔음")
        return target
    }
    
    func createDMRoom(dm: DMs) {
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID }),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == dm.workspaceID }) else { return }
        
        guard let _ = workspace.dmList.first(where: { $0.roomID == dm.roomID}) else {
            let newDMRoom = DM(dm: dm)

            do {
                try realm.write {
                    workspace.dmList.append(newDMRoom)
                    print("새로운 DM Room 생성 완료")
                }
            } catch {
                print("새로운 DM Room 생성 실패")
            }
            print("DM데이터 체크")
            return
        }
    }
    
    func updateDM(workspaceID: Int, dm: DMChatModel) {
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID }),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == workspaceID }),
              let dmRoom = workspace.dmList.first(where: { $0.roomID == dm.roomID}) else {
            print("아무것도 생성안함")
            return }
        
        do {
            try realm.write {
                let new = DMDataSource(dm: dm)
                dmRoom.dmData.append(new)
                print("새로운 DM 채팅 생성 완료")
            }
        } catch {
            print("새로운 DM 채팅 생성 실패")
        }
    }
    
    func updateUnreadDM(dm: DMChatResponse) {
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == dm.workspaceID }),
              let dmRoom = workspace.dmList.first(where: { $0.roomID == dm.roomID}) else { return }
        let new = dm.chats.map { DMDataSource(dm: $0) }
        
        do {
            try realm.write {
                dmRoom.dmData.append(objectsIn: new)
                print("새로운 DM 채팅 생성 완료")
            }
        } catch {
            print("새로운 DM 채팅 생성 실패")
        }
    }
    
    func removeDMRoom(workspaceID: Int, dm: DMs) {
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == workspaceID }),
              let dmRoom = workspace.dmList.first(where: { $0.roomID == dm.roomID}) else { return }
        
        do {
            try realm.write {
                dmRoom.dmData.forEach {
                    guard let user = $0.user else { return }
                    realm.delete(user)
                }
                realm.delete(dmRoom.dmData)
                realm.delete(dmRoom)
            }
        } catch {
            print("DM 정보 지우기 실패")
        }
    }
    
    func getDMLatestChatData(workspaceID:Int, userID: Int) -> String? {
        guard let user = realm.objects(UserData.self).first(where: { $0.userID == self.userID}),
              let workspace = user.workspaceList.first(where: { $0.workspaceID == workspaceID }),
              let dmRoom = workspace.dmList.first(where: { $0.withUserID == userID }) else { return nil }
        if let written = dmRoom.dmData.last {
            return written.createdAt
        } else {
            return dmRoom.DMDatabaseCreatedAt
        }
    }
}
