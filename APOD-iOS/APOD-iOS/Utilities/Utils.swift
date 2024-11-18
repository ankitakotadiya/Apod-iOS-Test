import Foundation
import SwiftUI

struct Utils {
    enum DeviceType {
        case iPhone
        case iPad
    }
    
    // Determine the device type
    static var device: DeviceType {
        UIDevice.current.userInterfaceIdiom == .pad ? .iPad : .iPhone
    }
}

struct Defautls {
    // Start date for APOD data
    static let apodStartDate: String = "1995-06-16"
}

struct Links {
    static let apiKey = "5MvMTx3RcsNNsuh4kBxtjMspgnkoUOTvLT9VpFsR"
    static let host = "https://api.nasa.gov/planetary"
}

struct Images {
    static let failedImage = "exclamationmark.triangle"
}

struct Identifiers {
    enum Apod {
        static let datePicker = "DatePicker"
        static let fullScreenView = "FullScreenView"
        static let mediaContentView = "MediaContentView"
        static let apodImage = "ApodImage"
        static let navTitle = "APOD"
    }
    
    enum View {
        static let imageIndicator = "LoadingIndicator"
        static let mainIndicator = "MainLoadingIndicator"
    }
    
    enum UITest {
        static let api = "-ui-testing"
    }
    
}
