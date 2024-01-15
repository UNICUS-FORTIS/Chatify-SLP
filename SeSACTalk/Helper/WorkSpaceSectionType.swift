//
//  WorkSpaceSectionType.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/15/24.
//

import Foundation
import RxDataSources


enum WorkSpaceSectionType: CaseIterable {
    case channel
    case directMessage
    case memberManagement
}

struct SectionItem {
    var sectionType: WorkSpaceSectionType
}

struct SectionModel {
    var items: [SectionItem]
}

extension SectionModel: SectionModelType {
    
    typealias Item = SectionItem
    
    init(original: SectionModel, items: [Item]) {
        self = original
        self.items = items
        
    }
}
