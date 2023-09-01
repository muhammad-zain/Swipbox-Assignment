//
//  BaseViewController.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var alertPresenter: AlertPresenter = {
        return AlertPresenter(self)
    }()
    
    deinit {
        debugPrint("deinit \(type(of: self))")
    }
}
