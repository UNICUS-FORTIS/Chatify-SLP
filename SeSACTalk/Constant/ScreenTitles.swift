//
//  ScreenTitles.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import Foundation


enum ScreenTitles {
    
    enum Onboarding {
        static let mainTitle =
            """
            새싹톡을 사용하면 어디서나
            팀을 모을 수 있습니다.
            """
        static let startButton = "시작하기"
        
        enum BottomSheet {
            static let emailLoginButton = "이메일로 계속하기"
            static let joinButton = "또는 새롭게 회원가입 하기"
        }
    }
    
    enum WorkSpaceInitial {
        static let mainTitle = "출시 준비 완료!"
        static let subTitle = """
        님의 조직을 위해 새로운 새싹톡 워크스페이스를
        시작할 준비가 완료되었어요!
        """
        static let createWorkSpace = "워크스페이스 생성"
        static let notFoundWorkSpace = "워크스페이스를 찾을 수 없어요."
        static let requireNewWorkSpace = """
        관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나
        새로운 워크스페이스를 생성해주세요.
        """
    }
}
