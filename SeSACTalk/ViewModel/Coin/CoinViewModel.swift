//
//  CoinViewModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 3/1/24.
//

import Foundation
import RxSwift
import RxCocoa


final class CoinViewModel {
    
    private let networkService = NetworkService.shared
    private let session = LoginSession.shared
    let productListRelay = BehaviorRelay<ProductList>(value: [])
    let successReceiverRelay = PublishRelay<Bool>()
    let errorReceiverRelay = PublishRelay<CoinErrors>()
    var successActor: ( () -> Void )?
    private let disposeBag = DisposeBag()
    
    init() {
        fetchProductList()
    }
    
    private func fetchProductList() {
        networkService.fetchRequest(endpoint: .loadProductList,
                                    decodeModel: ProductList.self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let response):
                
                owner.productListRelay.accept(response)
                
            case .failure(let error):
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func fetchPurchaseValidation(imp: String, merchant: String) {
        let uids = PurchaseValidationRequest(impUid: imp, merchantUid: merchant)

        networkService.fetchRequest(endpoint: .purchaseValidation(uids: uids),
                                    decodeModel: PurchaseValidationResponse.self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let response):
                if response.success == true {
                    owner.successReceiverRelay.accept(true)
                    owner.session.fetchMyProfile()
                    owner.successActor?()
                } else {
                    owner.errorReceiverRelay.accept(CoinErrors.cancel)
                }
            case .failure(let error):
                guard let errorCase = CoinErrors(rawValue: error.errorCode) else { return }
                owner.errorReceiverRelay.accept(errorCase)
            }
        }
        .disposed(by: disposeBag)
    }
}


