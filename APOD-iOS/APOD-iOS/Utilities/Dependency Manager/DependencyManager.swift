import Foundation

// Provides mock service in UI testing mode.
struct DependencyManager {

    static var apodService: ApodFetching {
        if ProcessInfo.processInfo.arguments.contains(Identifiers.UITest.api) {
            return MockApodService()
        }
        return ApodService()
    }
    
    static var apodDataRepo: ApodDataFetching {
        if ProcessInfo.processInfo.arguments.contains(Identifiers.UITest.api) {
            return MockApodDataBaseService.shared
        }
        return ApodDataBaseService()
    }
}

