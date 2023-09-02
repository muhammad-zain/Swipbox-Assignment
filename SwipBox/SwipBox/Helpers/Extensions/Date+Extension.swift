//
//  Date+Extension.swift
//  SwipBox
//
//  Created by Zain Sidhu on 02/09/2023.
//

import Foundation

extension Date {
    func toString(dateFormat: DateFormats) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        return dateFormatter.string(from: self)
    }
}
