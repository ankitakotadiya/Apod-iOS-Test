import Foundation

protocol ApodFetching {
    func getApod(for params: [String: String]) async -> Result<Apod, NetworkError>
}

// The ApodService class is responsible for fetching Apod data from a remote API using a network manager. It works as centralised component between `Network` and `Viewmodel`
final class ApodService: ApodFetching {
    var networkManager: NetworkFetching
    
    init(networkManager: NetworkFetching = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getApod(for params: [String: String]) async -> Result<Apod, NetworkError> {
        do {
            let result = try await networkManager.getData(request: Apod.getApod(params: params))
            return result
        } catch {
            return .failure(.networkError)
        }
    }
}
