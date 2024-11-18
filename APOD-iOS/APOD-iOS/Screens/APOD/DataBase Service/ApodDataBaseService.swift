import Foundation
import CoreData

protocol ApodDataFetching {
    func fetchApod(for date: String) async -> Apod?
    func saveApod(_ apod: Apod) async throws
    func fetchLatestApod() async -> Apod?
    func pruneRecordsIfNeeded() async
}

// The `ApodDataBaseService` class provides a centralized way to manage `Apod` data persistence and retrieval from a Core Data database. It simplifies fetching specific or the latest `Apod` entries and ensures efficient saving of new `Apod` data, making it easier to work with local storage in the app.
final class ApodDataBaseService: ApodDataFetching {
    
    private let dataManager: DataBaseManaging
    
    init(dataManager: DataBaseManaging = DataBaseManager.shared) {
        self.dataManager = dataManager
    }
    
    func fetchApod(for date: String) async -> Apod? {
        let predicate = NSPredicate(format: "apodDate == %@", date)
        let descriptors = NSSortDescriptor(key: "date", ascending: false)
        let apodItems: [ItemApod] = await dataManager.fetchRequest(FetchQuery(predicate: predicate, sortDescriptor: [descriptors], fetchLimit: 1, fetchOffset: nil))
        
        return apodItems.first?.toModel()
    }
    
    func saveApod(_ apod: Apod) async throws {
        _ = ItemApod(context: dataManager.viewContext, item: apod)
        
        do {
            try await dataManager.saveContext()
        } catch let error {
            throw error
        }
    }
    
    func fetchLatestApod() async -> Apod? {
        let descriptors = NSSortDescriptor(key: "date", ascending: false)
        let apodItems: [ItemApod] = await dataManager.fetchRequest(FetchQuery(sortDescriptor: [descriptors], fetchLimit: 1))
        
        return apodItems.first?.toModel() ?? Apod.dummyObj
    }
    
    func pruneRecordsIfNeeded() async {
        let descriptors = NSSortDescriptor(key: "date", ascending: false)
        let query = FetchQuery(sortDescriptor: [descriptors], fetchLimit: 0, fetchOffset: 10)
        await dataManager.pruneOldRecords(query, entity: ItemApod.self)
    }
}
