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
    
    private lazy var provider = MoyaProvider<APIService>(session: Moya.Session(interceptor: RefreshTokenInterceptor()))
    private let disposeBag = DisposeBag()
    
    func fetchStatusCodeRequest(endpoint: APIService) -> Single<Result<Int, ErrorResponse>> {
        return Single.create { single in
            self.provider.rx.request(endpoint)
                .subscribe(with: self) { owner, response in
                    switch response.statusCode {
                    case 200:
                        single(.success(.success(response.statusCode)))
                        print(response.statusCode)
                    default:
                        do {
                            if let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) {
                                single(.success(.failure(decodedError)))
                            }
                        }
                    }
                }
        }
    }
    
    func fetchRequest<T: Decodable>(endpoint: APIService, decodeModel: T.Type) -> Single<Result<T, ErrorResponse>> {
        return Single.create { single in
            self.provider.rx.request(endpoint)
                .subscribe(with: self) { owner, response in
                    switch response.statusCode {
                    case 200:
                        if let decodedResponse = try? JSONDecoder().decode(decodeModel, from: response.data) {
                            single(.success(.success(decodedResponse)))
                        }
                    default:
                        do {
                            if let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) {
                                single(.success(.failure(decodedError)))
                                
                            }
                        }
                    }
                }
        }
    }
}
