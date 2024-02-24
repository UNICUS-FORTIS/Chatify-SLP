//
//  OnboardingViewmodel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/9/24.
//


import Foundation
import RxSwift
import RxCocoa



final class OnboardingViewModel {
    
    let networkService = NetworkService.shared
    var joinPagePushTrigger: (() -> Void)?
    var emailLoginPushTrigger: (()-> Void)?
    var afterLoginSucceedTrigger: (() -> Void)?
    let deviceToken = UserDefaults.standard.value(forKey: "tempDeviceToken") as? String
    lazy var appleFullName = UserDefaults.standard.string(forKey: "AppleLoginName")
    lazy var appleEmail = UserDefaults.standard.string(forKey: "AppleLoginEmail")
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    
    private let disposeBag = DisposeBag()
    
    func sortResponseByDate(_ response: [WorkSpace]) -> [WorkSpace] {
        let sortedResponse = response.sorted { (workspace1, workspace2) in
            if let date1 = dateFormatter.date(from: workspace1.createdAt),
               let date2 = dateFormatter.date(from: workspace2.createdAt) {
                return date1 > date2
            }
            return false
        }
        return sortedResponse
    }
    
    
    
    func fetchLoadWorkSpace() -> Single<Result<WorkSpaces, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .loadWorkSpace,
                                           decodeModel: WorkSpaces.self)
    }
    
    func saveRecentWorkspace(workspaces: WorkSpaces) {
        UserDefaults.createRecentWorkspace(workspaces: workspaces)
    }
}
