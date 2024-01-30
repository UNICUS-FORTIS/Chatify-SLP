//
//  RxDatasources.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/30/24.
//

import Foundation
import RxDataSources


enum MultipleSectionModel {
    case channel(items:[SectionItem])
    case dms(items: [SectionItem])
    case member
}

enum SectionItem {
    case channel(channel: Channels)
    case dms(dms: DMs)
    case member
}

extension MultipleSectionModel: SectionModelType {
    
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .channel(let items):
            return items.map {$0}
        case .dms(let items):
            return items.map {$0}
        case .member:
            return []
        }
    }
    
    init(original: MultipleSectionModel, items: [SectionItem]) {
        switch original {
        case .channel(let items):
            self = .channel(items: items)
        case .dms(let items):
            self = .dms(items: items)
        case .member:
            self = .member
        }
    }
}
