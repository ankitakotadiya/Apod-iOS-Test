import Foundation
import Combine
import CoreData

enum ApodState: Equatable {
    static func == (lhs: ApodState, rhs: ApodState) -> Bool {
        return true
    }
    
    case loading
    case loaded(Apod?)
    case error(String)
    
    // A computed property to access the Apod object when the state is loaded, or nil for other states.
    var apod: Apod? {
        switch self {
        case .loaded(let apod):
            return apod
        case .loading, .error(_):
            return nil
        }
    }
}

final class ApodViewModel: ObservableObject {
    var apodService: ApodFetching
    var dateFormatting: DateFormatting
    var apodDataRepo: ApodDataFetching
    @Published var state: ApodState = .loading
    
    init(
        apodService: ApodFetching = DependencyManager.apodService,
        dateFormatting: DateFormatting = DefaultDateFormatter(),
        apodDataRepo: ApodDataFetching = DependencyManager.apodDataRepo
    ) {
        self.apodService = apodService
        self.dateFormatting = dateFormatting
        self.apodDataRepo = apodDataRepo
    }
    
    // Loads the APOD for the specified date by first checking the local database, then fetching from the network if necessary, and finally updating the state.
    @MainActor
    func load(strDate: String) async {
        state = .loading
        if let apodItem = await apodDataRepo.fetchApod(for: strDate) {
            self.state = .loaded(apodItem)
        } else {
            let result = await apodService.getApod(for: ["date": strDate])
            
            switch result {
            case .success(let apod):
                self.state = .loaded(apod)
                await saveItemtoDatabase(apod)
            case .failure(_):
                self.state = .loaded(await apodDataRepo.fetchLatestApod())
            }
        }
    }
    
    func cleanUpResource() async {
        await apodDataRepo.pruneRecordsIfNeeded()
    }
    
    private func saveItemtoDatabase(_ _item: Apod) async {
        do {
            try await apodDataRepo.saveApod(_item)
        } catch let error {
            self.state = .error(error.localizedDescription)
        }
    }
}
