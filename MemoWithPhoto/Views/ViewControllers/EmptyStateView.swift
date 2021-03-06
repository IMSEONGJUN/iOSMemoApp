//
//  EmptyStateView.swift
//  iOSMemoAppLinePlus
//
//  Created by SEONGJUN on 2020/02/15.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

final class EmptyStateView: UIViewController {
    
    // MARK: Properties
    let messageLabel = NotiLabel(textAlignment: .center, fontSize: 18)
    let logoImageView = UIImageView()
    let createNewButton = UIButton()
    
    var isOnTheCreateNewOrDetailVC = false
    
    var token: NSObjectProtocol?
    
    var padding:CGFloat = 5
    
    
    // MARK: Initializer
    init(message: String, imageName: String) {
        messageLabel.text = message
        logoImageView.image = UIImage(named: imageName)
        super.init(nibName: nil, bundle: nil)
        print("EmptyStateView: initializer")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        view.backgroundColor = .white
        print("EmptyStateView: viewDidLoad")
        configure()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNotiObserver()
    }
    
    deinit{
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
        print("EmptyStateView Deinit")
    }
    
    
    // MARK: - Setup
    private func configure() {
        view.addSubview(messageLabel)
        view.addSubview(logoImageView)
        view.addSubview(createNewButton)
        
        messageLabel.numberOfLines = 2
        messageLabel.backgroundColor = MyColors.brown
        messageLabel.textColor = .white
        
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        createNewButton.setImage(UIImage(named: "plus"), for: .normal)
        createNewButton.addTarget(self, action: #selector(didTapCreateNewButton), for: .touchUpInside)
        createNewButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            createNewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createNewButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: padding),
            createNewButton.widthAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.4),
            createNewButton.heightAnchor.constraint(equalTo: createNewButton.widthAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: logoImageView.topAnchor, constant: -padding)
        ])
    }
    
    private func setNotiObserver() {
        if isOnTheCreateNewOrDetailVC {
            token = NotificationCenter.default.addObserver(forName: EmptyStateView.didTapNewImageAddedButton,
                                                           object: nil,
                                                           queue: OperationQueue.main,
                                                           using: { [weak self] (noti) in
                                                            guard let self = self else { return }
                                                            if let vc = self.parent as? ImageCollectionForCreateAndEdit{
                                                                self.checkSelfHaveChildrenVC(on: vc)
                                                                vc.presentActionSheetToSelectImageSource()
                                                            }
            })
        } else {
            token = NotificationCenter.default.addObserver(forName: EmptyStateView.didTapNewMemoCreatedButton,
                                                           object: nil,
                                                           queue: OperationQueue.main,
                                                           using: { [weak self] (noti) in
                                                            guard let self = self else { return }
                                                            if let vc = self.parent as? MemoListViewController {
                                                                vc.didTapAddNewMemoButton()
                                                            }
            })
        }
    }
    
    
    // MARK: - Action Handle
    
    @objc private func didTapCreateNewButton() {
        if isOnTheCreateNewOrDetailVC {
            print("add image")
            NotificationCenter.default.post(name: EmptyStateView.didTapNewImageAddedButton, object: nil)
        } else {
            print("add memo")
            NotificationCenter.default.post(name: EmptyStateView.didTapNewMemoCreatedButton, object: nil)
        }
    }
    
    
}

    // MARK: - Notification Names
extension EmptyStateView {
    static let didTapNewMemoCreatedButton = Notification.Name(rawValue: "didTapCreateNewMemoButton")
    static let didTapNewImageAddedButton = Notification.Name(rawValue: "didTapNewImageAddedButton")
}
