import Foundation
import SwiftUI

extension DynamicTypeSize {
    // Defines a custom range of dynamic type sizes based on the device type
    static var customDeviceSize: ClosedRange<DynamicTypeSize> {
        switch Utils.device {
        case .iPhone:
            return DynamicTypeSize.xSmall...DynamicTypeSize.accessibility1
        case .iPad:
            return DynamicTypeSize.xLarge...DynamicTypeSize.accessibility5
        }
    }
    
    // Specifies the default dynamic type size
    static var defaultSize: DynamicTypeSize {
        return .large
    }
}
