//
//  DataBaseManager.swift
//  APOD-iOS
//
//  Created by Ankita Kotadiya on 13/11/24.
//

import Foundation
import CoreData

// A `FetchQuery` structure used for specifying parameters for Core Data fetch requests.
struct FetchQuery {
    var predicate: NSPredicate?
    var sortDescriptor: [NSSortDescriptor]
    var fetchLimit: Int?
    var fetchOffset: Int?
    
    init(predicate: NSPredicate? = nil, sortDescriptor: [NSSortDescriptor] = [], fetchLimit: Int? = nil, fetchOffset: Int? = nil) {
        self.predicate = predicate
        self.sortDescriptor = sortDescriptor
        self.fetchLimit = fetchLimit
        self.fetchOffset = fetchOffset
    }
}

// Protocol that defines the required methods for managing a Core Data context and performing operations.
protocol DataBaseManaging {
    var viewContext: NSManagedObjectContext {get}
    func saveContext() async throws
    func delete<T: NSManagedObject>(entity: T) async throws
    func fetchRequest<T: NSManagedObject>(_ query: FetchQuery?) async -> [T]
    func pruneOldRecords<T: NSManagedObject>(_ query: FetchQuery?, entity: T.Type) async
}

// Class responsible for managing Core Data operations like saving, deleting, and fetching data.
final class DataBaseManager: DataBaseManaging, ObservableObject {
    
    static let shared = DataBaseManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SpaceGallery")
        container.loadPersistentStores { persistentStore, error in
            if let error = error {
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() async throws {
        guard viewContext.hasChanges else {return}
        
        try await viewContext.perform { [weak self] in
            guard let self = self else { return }
            
            do {
                try self.viewContext.save()
            } catch {
                throw error
            }
        }
    }
    
    func delete<T: NSManagedObject>(entity: T) async throws {
        viewContext.delete(entity)
        try await self.saveContext()
    }
    
    func fetchRequest<T: NSManagedObject>(_ query: FetchQuery?) async -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = query?.predicate
        request.sortDescriptors = query?.sortDescriptor
        
        if let limit = query?.fetchLimit {
            request.fetchLimit = limit
        }
        
        do {
            return try await viewContext.perform { [weak self] in
                guard let self = self else {return [] }
                return try self.viewContext.fetch(request)
            }
        } catch {
            return []
        }
    }
    
    func pruneOldRecords<T: NSManagedObject>(_ query: FetchQuery?, entity: T.Type) async {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity.self))
        fetchRequest.sortDescriptors = query?.sortDescriptor
        fetchRequest.predicate = query?.predicate
        
        do {
            // Fetch the total count of records
            let count = try await viewContext.perform { [weak self] in
                try self?.viewContext.count(for: fetchRequest)
            }
            
            // Check if pruning is necessary
            guard count ?? 0 > query?.fetchOffset ?? 100 else {
                return
            }
            
            // Modify fetchRequest for deletion
            fetchRequest.fetchOffset = query?.fetchOffset ?? 100 // Skip the first `maxCount` records
            if let limit = query?.fetchLimit {
                fetchRequest.fetchLimit = limit
            }
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            // Execute the delete request
            _ = try await viewContext.perform { [weak self] in
                try self?.viewContext.execute(deleteRequest)
            }
        } catch {
            //            throw error
        }
    }
}
