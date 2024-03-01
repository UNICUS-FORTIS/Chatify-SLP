//
//  CoinViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/29/24.
//

import UIKit
import SnapKit
import RxSwift
import WebKit
import iamport_ios


final class CoinViewController: UIViewController {
    
    private let session = LoginSession.shared
    private let viewModel = CoinViewModel()
    private let titleView = CustomCoinView()
    private let disposeBag = DisposeBag()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    lazy var webView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Iamport.shared.close()
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(titleView)
        view.addSubview(tableView)
        tableView.rowHeight = 44
        tableView.backgroundColor = .clear
        tableView.register(ProductListCell.self,
                           forCellReuseIdentifier: ProductListCell.identifier)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 0,
                                                         height: CGFloat.leastNonzeroMagnitude))
        navigationController?.setDefaultNavigation(target: self, title: "코인샵")
    }
    
    private func setConstraints() {
        
        titleView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func bind() {
        
        viewModel.productListRelay
            .bind(to: tableView.rx.items(cellIdentifier: ProductListCell.identifier,
                                         cellType: ProductListCell.self)) {
                row, item, cell in
                
                cell.bindData(product: item)
                cell.buttonAction = { [weak self] in
                    self?.makePurchaseAction(item: item)
                }
                
            }.disposed(by: disposeBag)
        
        session.myProfile
            .bind(with: self) { owner, profile in
                guard let coin = profile?.sesacCoin else { return }
                owner.titleView.manageCoinCount(coin: coin)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorReceiverRelay
            .subscribe(with: self) { owner, errors in
                owner.makeSuccessToastView(message: errors.description,
                                           backgroundColor: Colors.Brand.error,
                                           target: owner)
            }
            .disposed(by: disposeBag)
    }
    
    func makePurchaseAction(item: ProductListResponse) {
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(SecureKeys.makeSecretKey())_\(Int(Date().timeIntervalSince1970))",
            amount: "\(item.amount)").then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = item.item
                $0.buyer_name = "신결"
                $0.app_scheme = "chatify.payment"
            }
        
        viewModel.successActor = { [weak self] in
            self?.makeSuccessToastView(message: ToastMessages.Coin.purchaseCompleted(coin: item.item).description,
                                       backgroundColor: Colors.Brand.identity,
                                       target: self!)
        }
        
        Iamport.shared.paymentWebView(webViewMode: webView,
                                      userCode: "imp57573124",
                                      payment: payment) { [weak self] response in

            guard let imp = response?.imp_uid,
                  let merchat = response?.merchant_uid else { return }
            self?.viewModel.fetchPurchaseValidation(imp: imp,
                                              merchant: merchat)
            self?.webView.removeFromSuperview()
        }
    }
}

extension CoinViewController: ToastPresentableProtocol { }
