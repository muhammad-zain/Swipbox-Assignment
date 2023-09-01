//
//  AlertPresenter.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import UIKit

final class AlertPresenter {
    
    private weak var viewController: UIViewController!
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showErrorMessageAlert(title: String = "Error", message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        viewController.present(alertController, animated: true)
    }
}
