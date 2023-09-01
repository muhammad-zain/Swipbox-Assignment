//
//  UIStoryboard+Extension.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import Foundation

import UIKit

extension UIStoryboard {
    
    func instantiateViewController<T>(ofType type: T.Type, identifier: String? = nil) -> T {
        let identifier = identifier ?? String(describing: type)
        
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Expected view vontroller with identifier \(identifier) to be of type \(type)")
        }
        
        return viewController
    }
    
    static var main: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }
}
