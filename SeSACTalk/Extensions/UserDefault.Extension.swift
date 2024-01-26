//
//  Userdefault.Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/27/24.
//

import Foundation

extension UserDefaults {
    
    static func createRecentWorkspace(workspaces: WorkSpaces) {
        guard let first = workspaces.first?.workspaceID else { return }
        Self.standard.setValue(first, forKey: "recentWorkspace")
    }
    
    static func loadRecentWorkspace() -> Int? {
        return Self.standard.integer(forKey: "recentWorkspace")
    }
    
    
    
}
