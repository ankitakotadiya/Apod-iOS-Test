import Foundation

enum MockError: Error {
    case networkError
}

final class MockApodService: ApodFetching {
    var isError: Bool = false
    
    private func returnApod(for date: String?) -> Apod {
        switch date {
        case Constants.Dates.testDate:
            return Apod.testValue
        
        default:
            return Apod.testValue
        }
    }
    
    // Return mock apod on success and throw error in case.
    func getApod(for params: [String : String]) async -> Result<Apod, NetworkError> {
        if let date = params["date"] {
            Constants.Dates.testDate = date
        }
        return isError ? .failure(.networkError) : .success(returnApod	(for: params["date"]))
    }
}
