import Foundation
import UIKit
@testable import APOD_iOS

final class MockNetworkManager: NetworkFetching {
    var isError: Bool = false
    
    private let apodJsonString: String = {
        // Mock APOD response
        return """
                {
                  "date": "2024-11-16",
                  "explanation": "Test Explanation",
                  "media_type": "image",
                  "service_version": "v1",
                  "title": "Test Title",
                  "url": "https://"
                }
            """
    }()
    
    private func getJson<T: Decodable>(of type: T.Type) -> String {
        if type == Apod.self {
            return apodJsonString
        } 
        return ""
    }
    
    // Decodes a JSON string into the specified Decodable type
    private func decodeJson<T: Decodable>(type: T.Type) -> T? {
        let jsonString = getJson(of: type)
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(type.self, from: data)
        } catch {
            fatalError("Data is not able to parse: \(error.localizedDescription)")
        }
    }
    
    // Mocks fetching data by returning either success with decoded object or a network error
    func getData<T: Decodable>(request: Request<T>) async throws -> Result<T, NetworkError> {
        if isError {
            return .failure(.networkError)
        } else {
            if let jsonObject = self.decodeJson(type: T.self) {
                return .success(jsonObject)
            } else {
                return .failure(.decodingError)
            }
        }
    }
    
    func downloadData(from url: URL?) async -> Result<Data, NetworkError> {
        if isError {
            return .failure(.networkError)
        } else {
            // Load dummy image from the test bundle
            let bundle = Bundle(for: MockNetworkManager.self)
            guard let path = bundle.path(forResource: "TestGif", ofType: "gif"),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return .failure(.decodingError)
            }
            return .success(data)
        }
    }
}
