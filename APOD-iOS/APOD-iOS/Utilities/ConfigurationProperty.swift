import Foundation
import SwiftUI

struct PlistManager {
    enum PlistManagerError: Error {
        case fileNotFound
        case serializationError(Error)
    }
    
    static func loadPlist(named name: String) throws -> [String: Any]? {
        guard let data = getData(named: name) else {
            throw PlistManagerError.fileNotFound
        }
        do {
            return try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]
        } catch {
            throw PlistManagerError.serializationError(error)
        }
    }

    static func savePlist(named name: String, with updatedContent: [String: Any]) throws {
        guard let path = getPath(named: name) else {
            throw PlistManagerError.fileNotFound
        }
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: updatedContent, format: .xml, options: 0)
            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        } catch {
            throw PlistManagerError.serializationError(error)
        }
    }

    // Static helper for retrieving the file path of a plist.
    private static func getPath(named name: String) -> String? {
        Bundle.main.path(forResource: name, ofType: "plist")
    }

    // Static helper for retrieving the data of a plist file.
    private static func getData(named name: String) -> Data? {
        guard let path = getPath(named: name) else {
            return nil
        }
        return FileManager.default.contents(atPath: path)
    }
}

// Custom property wrapper
@propertyWrapper
struct ConfigurationProperty: DynamicProperty {
    @State private var value: String
    let key: String
    private let plistName = "Config"
    
    var wrappedValue: String {
        get { value }
        nonmutating set {
            value = newValue
            save(newValue: newValue)
        }
    }
    
    init(wrappedValue: String, _ key: String) {
        self.key = key
        do {
            let config = try PlistManager.loadPlist(named: plistName)
            if let loadedValue = config?[key] as? String {
                value = loadedValue
            } else {
                value = wrappedValue
            }
        } catch {
            self.value = wrappedValue
        }
    }
    
    private func save(newValue: String) {
        do {
            guard var config = try PlistManager.loadPlist(named: plistName) else {
                return
            }
            config[key] = newValue
            try PlistManager.savePlist(named: plistName, with: config)
        } catch {
        }
    }
}
