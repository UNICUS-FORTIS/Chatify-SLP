//
//  AppleLoginManager.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/10/24.
//

import Foundation
import LocalAuthentication

final class AppleLoginManager {
    
    var selectedPolicy: LAPolicy = .deviceOwnerAuthentication
    
    func auth() {
        
        let context = LAContext()
        context.localizedCancelTitle = "FacdID 인증 취소"
        context.localizedFallbackTitle = "비밀번호 대신 FaceID 사용하기"
        context.evaluatePolicy(selectedPolicy, localizedReason: "페이스 아이디 인증이 필요합니다") {
            result, error in
            
            if let error {
                let code = error._code
                guard let laErrorCode = LAError.Code(rawValue: code) else { return }
                let laError = LAError(laErrorCode)
                print(laError)
            }
        }
    }
    
    func checkPolicy() -> Bool {
        let context = LAContext()
        let policy: LAPolicy = selectedPolicy
        return context.canEvaluatePolicy(policy, error: nil)
    }
    
    func isFaceIDChanged() -> Bool {
        let context = LAContext()
        context.canEvaluatePolicy(selectedPolicy, error: nil)
        
        let state = context.evaluatedPolicyDomainState // 이게 생체 인증에 대한 정보임. 사람마다 고유한 데이터를 갖게됨
        
        //생체 인증 정보를 UserDefault 에 저장
        //기존에 저장된 domainState와 새롭게 변경된 domainState 를 비교했을때 ->
        print(state)
        return false // 여기서 로직 추가
    }
    
}
