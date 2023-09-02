//
//  MovieModel+CoreDataProperties.swift
//  SwipBox
//
//  Created by Zain Sidhu on 02/09/2023.
//
//

import Foundation
import CoreData


extension MovieModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieModel> {
        return NSFetchRequest<MovieModel>(entityName: "MovieModel")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var tagline: String?
    @NSManaged public var overview: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var rating: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var backdropPath: String?

}

extension MovieModel : Identifiable {

}
