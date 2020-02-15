//
//  UIViewController+Ext.swift
//  iOSMemoAppLinePlus
//
//  Created by SEONGJUN on 2020/02/15.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String = "확인") {
        DispatchQueue.main.async {
            let alertVC = AlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView, imageName: String) {
        let emptyStateView = EmptyStateView(message: message, imageName: imageName)
        addChild(emptyStateView)
        view.addSubview(emptyStateView.view)
        emptyStateView.view.frame = view.bounds
        emptyStateView.didMove(toParent: self)
    }

}

