import Foundation
import CoreData
@testable import APOD_iOS

// This class is for In-Memory data testing
final class MockDataBaseManager: DataBaseManaging {
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = true) {
        container = NSPersistentContainer(name: "MyModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    var fetchResult: [NSManagedObject]?
    
    
    func saveContext() async throws {
        guard viewContext.hasChanges else { return }
        try await viewContext.perform { [weak self] in
            try self?.viewContext.save()
        }
    }
    
    func delete<T>(entity: T) async throws where T : NSManagedObject {
        viewContext.delete(entity)
        try await saveContext()
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
    
    // Prune Record
    func pruneOldRecords<T>(_ query: FetchQuery?, entity: T.Type) async where T : NSManagedObject {
        
    }
}
