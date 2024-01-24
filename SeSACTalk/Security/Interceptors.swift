//
//  Interceptor.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/21/24.
//

import Foundation
import Alamofire
import RxSwift

final class RefreshTokenInterceptor: RequestInterceptor {
    
    private let networkmanager = NetworkService.shared
    private let disposeBag = DisposeBag()
    private var retryCount = 0
    private let maxRetryCount = 1
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var urlRequest = urlRequest
        
//        urlRequest.headers.update(name: SecureKeys.Headers.auth, value: SecureKeys.Headers.accessToken)
        
        completion(.success(urlRequest))
    }
    
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("========리트라이 시작")
        let dispatchGroup = DispatchGroup()
        
        if let response = request as? DataRequest {
            guard let errorData = response.data,
                  let decoded = try? JSONDecoder().decode(ErrorResponse.self, from: errorData)
            else { return completion(.doNotRetry) }
            let errorCode = APIError.ErrorCodes(rawValue: decoded.errorCode)
            
            switch errorCode {
            case .tokenExpired:
                if retryCount < maxRetryCount {
                    
                    retryCount += 1
                    
                    dispatchGroup.enter()
                    let token = AccessTokenRequest(accessToken: SecureKeys.createAccessToken())
                    networkmanager.fetchRequest(endpoint: .refreshToken(token: token),
                                                decodeModel: AccessTokenRequest.self)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let response) :
                            SecureKeys.saveNewAccessToken(token: response.accessToken)
                            print("토큰저장완료")
                            completion(.retry)
                            dispatchGroup.leave()
                            
                        case .failure(let error) :
                            print(error.errorCode)
                            completion(.doNotRetry)
                            dispatchGroup.leave()
                            
                        }
                    }
                    .disposed(by: disposeBag)
                } else {
                    completion(.doNotRetry)
                }
                
            default: break
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.retry)
        }
    }
}

