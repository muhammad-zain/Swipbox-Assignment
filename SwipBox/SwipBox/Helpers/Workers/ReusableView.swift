//
//  ReusableView.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import Foundation

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
