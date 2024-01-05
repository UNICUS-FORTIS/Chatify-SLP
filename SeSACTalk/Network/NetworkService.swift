//
//  NetworkService.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/4/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift

final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private let provider = MoyaProvider<APIService>()
    private let disposeBag = DisposeBag()
    
    func fetchRequest(info: EmailValidationRequest) -> Single<Result<Int, Error>> {
        print(#function)
        return Single.create { single in
            self.provider.rx.request(.emailValidation(model: info))
                .map { $0.statusCode }
                .subscribe(with: self) { owner, status in
                    switch status {
                    case 200 : single(.success(.success(status)))
                        print(status)
                    default : single(.success(.failure(APIError(rawValue: status) ?? .unknownError)))
                        print(status)
                    }
                }
        }
    }
}
