import Foundation

extension Apod {
    
    // Mock apod data
    static let testValue = Apod(
        date: Constants.Dates.testDate,
        explanation: "Test Explanation",
        media_type: "image",
        title: "Test Title",
        service_version: "v1",
        url: URL(string: "https://")
    )
}
