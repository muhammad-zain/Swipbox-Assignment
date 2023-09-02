//
//  MovieModel+CoreDataClass.swift
//  SwipBox
//
//  Created by Zain Sidhu on 02/09/2023.
//
//

import Foundation
import CoreData

@objc(MovieModel)
public class MovieModel: NSManagedObject, ModelMapper {
    
    static var idKey: String {
        return "id"
    }
    
    func parse(node: Dictionary<AnyHashable, Any>) throws {
    
    }
    
    static func fetchRequest(id: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest:NSFetchRequest<MovieModel> = MovieModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(idKey) == '\(id)'")
        return fetchRequest as! NSFetchRequest<NSFetchRequestResult>
    }
    
    var toMovieObject: MovieProtocol {
        return Movie(id: Int(id), title: title, tagline: tagline, overview: overview, releaseDate: releaseDate, rating: rating, posterPath: posterPath, backdropPath: backdropPath)
    }
    
}
