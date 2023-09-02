//
//  NSManagedObject+Common.swift
//  SwipBox
//
//  Created by Zain Sidhu on 02/09/2023.
//

import Foundation
import CoreData

enum ModelMapperError: Error {
    case mappingFailed
    case uniquenessViolation
}

protocol ModelMapper {
    
    static var entityName: String {get}
    static var idKey: String {get}
    
    func parse(node: Dictionary<AnyHashable, Any>) throws
    static func fetchRequest(id: String) -> NSFetchRequest<NSFetchRequestResult>
}

extension ModelMapper {
    static var entityName: String {
        return String(describing: self)
    }
}

