import Foundation

final class MockApodDataBaseService: ApodDataFetching {
    
    private let dateFormatter = DefaultDateFormatter()
    static let shared = MockApodDataBaseService()
    
    var apods: [Apod] = []
    
    // Fetch Apo
    func fetchApod(for date: String) async -> Apod? {
        return apods.filter({$0.date == date}).first
    }
    
    // In-Memory Save
    func saveApod(_ apod: Apod) async throws {
        apods.append(apod)
    }
    
    // Fetch Last Saved
    func fetchLatestApod() async -> Apod? {
        return apods.sorted(by: {dateFormatter.dateFromString($0.date) > dateFormatter.dateFromString($1.date)}).first ?? Apod.dummyObj
    }
    
    // Store only one record if cleanup occurs.
    func pruneRecordsIfNeeded() async {
        if apods.count > 1 {
            let count = apods.count - 1
            apods.removeLast(count)
        }
    }
}
