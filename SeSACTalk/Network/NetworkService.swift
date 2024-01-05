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
    
    func fetchRequest(info: EmailValidationRequest) -> Single<Result<Int, ErrorResponse>> {
        print(#function)
        return Single.create { single in
            self.provider.rx.request(.emailValidation(model: info))
                .subscribe(with: self) { owner, response in
                    switch response.statusCode {
                    case 200:
                        single(.success(.success(response.statusCode)))
                        print(response.statusCode)
                    default:
                        do {
                            let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                            single(.success(.failure(decodedError)))
                        } catch {
                            let unknownError = APIError(rawValue: response.statusCode)
                        }
                    }
                }
        }
    }
}
