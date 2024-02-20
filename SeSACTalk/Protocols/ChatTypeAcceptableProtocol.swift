//
//  ChatTypeAcceptable.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/31/24.
//

import UIKit


protocol ChatTypeAcceptableProtocol: AnyObject {
    
    var log:[ChatModel] { get set }
    
    func setNavigationAppearance(with: UIViewController, right: Selector?)
    func startSocketConnect()
    func loadChatLog()
    func fetchUnreadDatas()
    func appendNewChat()
}
