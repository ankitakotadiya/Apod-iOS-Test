import Foundation

enum Method: String {
    case get = "GET"
}

// A generic struct representing a network request, with a method, path, and optional query parameters.
struct Request<T> {
    var method: Method
    var path: String
    var queryParams: [String: String]
    
    init(method: Method = .get, path: String, queryParams: [String : String] = [:]) {
        self.method = method
        self.path = path
        self.queryParams = queryParams
    }
}
