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
    
    func fetchEmailValidationRequest(info: EmailValidationRequest) -> Single<Result<Int, ErrorResponse>> {
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
                            print(unknownError)
                        }
                    }
                }
        }
    }
    
    func fetchJoinRequest(info: SignInRequest) -> Single<Result<SignInResponse, ErrorResponse>> {
        print(#function)
        return Single.create { single in
            self.provider.rx.request(.join(model: info))
                .subscribe(with: self) { owner, response in
                    switch response.statusCode {
                    case 200:
                        if let decodedResponse = try? JSONDecoder().decode(SignInResponse.self, from: response.data) {
                            single(.success(.success(decodedResponse)))
                        }
                    default:
                        do {
                            let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                            single(.success(.failure(decodedError)))
                        } catch {
                            let unknownError = APIError(rawValue: response.statusCode)
                            print(unknownError)
                        }
                    }
                }
        }
    }
    
    
    func fetchEmailLoginRequest(info: EmailLoginRequest) -> Single<Result<EmailLoginResponse, ErrorResponse>> {
        return Single.create { single in
            self.provider.rx.request(.emailLogin(model: info))
                .subscribe(with: self)  { owner, response in
                    switch response.statusCode {
                    case 200:
                        if let decodedResponse = try? JSONDecoder().decode(EmailLoginResponse.self, from: response.data) {
                            single(.success(.success(decodedResponse)))
                        }
                    default:
                        do {
                            let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                            single(.success(.failure(decodedError)))
                        } catch {
                            let unknownError = APIError(rawValue: response.statusCode)
                            print(unknownError)
                        }
                    }
                }
        }
    }
    
    func fetchKakaoLoginRequest(info: KakaoLoginRequest) -> Single<Result<SignInResponse, ErrorResponse>> {
        print(#function)
        return Single.create { single in
            self.provider.rx.request(.kakaoLogin(model: info))
                .subscribe(with: self)  { owner, response in
                    switch response.statusCode {
                    case 200:
                        if let decodedResponse = try? JSONDecoder().decode(SignInResponse.self, from: response.data) {
                            single(.success(.success(decodedResponse)))
                        }
                    default:
                        do {
                            let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                            single(.success(.failure(decodedError)))
                        } catch {
                            let unknownError = APIError(rawValue: response.statusCode)
                            print(unknownError)
                        }
                    }
                }
        }
    }
    
    func fetchAppleLoginRequest(info: AppleLoginRequest) -> Single<Result<SignInResponse, ErrorResponse>> {
        print(#function)
        return Single.create { single in
            self.provider.rx.request(.appleLogin(model: info))
                .subscribe(with: self)  { owner, response in
                    switch response.statusCode {
                    case 200:
                        if let decodedResponse = try? JSONDecoder().decode(SignInResponse.self, from: response.data) {
                            single(.success(.success(decodedResponse)))
                        }
                    default:
                        do {
                            let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                            single(.success(.failure(decodedError)))
                        } catch {
                            let unknownError = APIError(rawValue: response.statusCode)
                            print(unknownError)
                        }
                    }
                }
        }
    }
    
}
