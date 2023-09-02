//
//  DataModel.swift
//  SwipBox
//
//  Created by Zain Sidhu on 02/09/2023.
//

import Foundation
import CoreData

typealias JSON = [String: Any]

final class DataModel {
    static let shared = DataModel()
    
    private init() {}
    
    private lazy var managedObjectContext = persistentContainer.viewContext
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Swipbox")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func emptyObject(name: String) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: name, in: managedObjectContext)!
        return NSManagedObject(entity:entity, insertInto:managedObjectContext)
    }
    
    // MARK: private
    private func fetchUniqueEntity(request: NSFetchRequest<NSFetchRequestResult>) -> Any? {
        let fetchedObjects = fetchEntities(request: request)
        assert(fetchedObjects.count <= 1, "only one object can exist with specified id")
        
        if fetchedObjects.count > 1 {
            for fetchedObject in fetchedObjects {
                managedObjectContext.delete(fetchedObject as! NSManagedObject)
            }
            return nil
        } else if fetchedObjects.count == 1 {
            return fetchedObjects[0]
        }
        
        return nil
    }
    
    private func recycleUniqueEntity(entity: ModelMapper.Type, id: String) -> Any {
        guard let fetchedEntity = fetchUniqueEntity(request: entity.fetchRequest(id: id)) else {
            return emptyObject(name: entity.entityName)
        }
        
        return fetchedEntity
    }
    
    func remove(object: NSManagedObject)  {
        managedObjectContext.delete(object)
    }
    
    private func remove(entity: ModelMapper.Type) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity.entityName)
        assert(Thread.isMainThread, "remove entity should be performed on main thread")
        do {
            let objects = try managedObjectContext.fetch(fetchRequest)
            for object in objects {
                managedObjectContext.delete(object)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: public
    func entity<T: ModelMapper>(entity: T.Type, id: String) -> T? {
        return recycleUniqueEntity(entity: entity, id: id) as? T
    }
    
    func fetchEntities(request: NSFetchRequest<NSFetchRequestResult>) -> [Any] {
        do {
            let fetchedObjects = try managedObjectContext.fetch(request)
            return fetchedObjects
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
    }
    
    func saveContext () {
        assert(Thread.isMainThread, "saveContext should be performed on main thread")
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolve error \(error), \(error.userInfo)")
            }
        }
    }
    
    func getFetchedResultController<T: ModelMapper>(for fetchRequest: NSFetchRequest<T>, sectionNameKeyPath: String? = nil, cacheName name: String? = nil) -> NSFetchedResultsController<T> {
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    //MARK: Parsing
    func parseObjectList<T: ModelMapper>(entity: T.Type, data: [Dictionary<String, Any>], _ recycle: Bool = true) -> [T] {
        var list = [T]()
        
        for node in data {
            if let parsedObject = parseObject(entity: entity, data: node, recycle) {
                list.append(parsedObject)
            }
        }
        
        return list
    }
    
    func parseObject<T: ModelMapper>(entity: T.Type, data: Dictionary<String, Any>, _ recycle: Bool = true) -> T? {
        if recycle {
            
            guard let id = data[entity.idKey], let fetchedEntity = recycleUniqueEntity(entity: entity, id: "\(id)") as? T else {
                return nil
            }
            
            do {
                try fetchedEntity.parse(node: data)
                return fetchedEntity
            } catch {
                if let managedObject = fetchedEntity as? NSManagedObject {
                    remove(object: managedObject)
                }
                return nil
            }
        } else {
            let emptyEntity = emptyObject(name: entity.entityName) as? T
            do {
                try emptyEntity?.parse(node: data)
                return emptyEntity
            } catch {
                if let managedObject = emptyEntity as? NSManagedObject {
                    remove(object: managedObject)
                }
                return nil
            }
        }
    }
    
    func fetchMovies(fetchOffset offset: Int, fetchLimit limit: Int = 20) -> [MovieModel]? {
        let fetchRequest: NSFetchRequest<MovieModel> = MovieModel.fetchRequest()
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        return fetchEntities(request: fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [MovieModel]
    }
}


