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
        return dateFormatter.date(from: self)
    }
}
