//
//  String+Extension.swift
//  SwipBox
//
//  Created by Zain Sidhu on 02/09/2023.
//

import Foundation

extension String {
    func toDate(dateFormat: DateFormats) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        
        if let date = dateFormatter.date(from: self), dateFormatter.string(from: date) == self {
            return date
        } else {
            return nil
        }
    }
}
