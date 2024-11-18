
import Foundation
import SwiftUI

protocol NetworkFetching {
    func getData<T: Decodable>(request: Request<T>) async throws -> Result<T, NetworkError>
    func downloadData(from url: URL?) async -> Result<Data, NetworkError>
}

// An enum representing different error types that can occur during network requests.
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError
}

// A class responsible for handling network requests, implementing the NetworkFetching protocol.
final class NetworkManager: NetworkFetching {
    @ConfigurationProperty("api_key") private var api_key: String = "" // Pass default value in case fail
    @ConfigurationProperty("host") private var host: String = "" // Pass default value in case fail
//    let apiKey = Links.apiKey
//    let host = Links.host
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func getData<T: Decodable>(request: Request<T>) async throws -> Result<T, NetworkError> {
        do {
            let urlRequest = try urlRequest(for: request)
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            // Check if response has valid HTTP status code
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(NetworkError.invalidResponse)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(NetworkError.decodingError)
            }
            
        } catch {
            return .failure(NetworkError.networkError)
        }
    }
    
    // Downloads raw data from the given URL asynchronously.
    func downloadData(from url: URL?) async -> Result<Data, NetworkError> {
        do {
            guard let url = url else {
                return .failure(.invalidURL)
            }
            let (data, response) = try await urlSession.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(.invalidResponse)
            }
            
            return .success(data)
        } catch {
            return .failure(.networkError)
        }
    }
    
    private func urlRequest<Value>(for _request: Request<Value>) throws -> URLRequest {
        guard let url = URL(host, api_key, _request) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = _request.method.rawValue
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return request
    }
}

extension URL {
    // Appends query items to the URL and returns the updated URL.
    func url(with queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var existingComponents: [URLQueryItem] = components?.queryItems ?? []
        existingComponents.append(contentsOf: queryItems)
        components?.queryItems = existingComponents
        
        return components?.url
    }
    
    // Initializes a URL with a host, API key, and request, appending the appropriate query parameters.
    init?<Value>(_ host: String, _ apiKey: String, _ request: Request<Value>) {
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        queryItems += request.queryParams.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        guard let baseURL = URL(string: host) else {
            return nil
        }
        
        let urlPath = baseURL.appendingPathComponent(request.path).url(with: queryItems)
        
        guard let urlString = urlPath?.absoluteString else {
            return nil
        }
        
        self.init(string: urlString)
    }
}
