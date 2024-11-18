//
//  Fonts.swift
import Foundation
import SwiftUI

extension Color {
    
    enum Custom {
        static let charcol: Color = Color(red: 22/255, green: 22/255, blue: 22/255)
        static let tealColor: Color = Color(red: 14/255, green: 110/255, blue: 109/255)
        static let extraLightTeal: Color = Color(red: 121/255, green: 205/255, blue: 199/255)
    }
    
    enum System {
        static let tertiarySystemBackground: Color = Color(uiColor: .tertiarySystemBackground)
        static let systemBackground: Color = Color(uiColor: .systemBackground)
    }
}

extension UIColor {
    
    enum Custom {
        static let charcol: UIColor = UIColor(Color.Custom.charcol)
        static let tealColor: UIColor = UIColor(Color.Custom.tealColor)
        static let extraLightTeal: UIColor = UIColor(Color.Custom.extraLightTeal)
    }
    
    static var navigationColor: UIColor {
        UIColor { interface in
            interface.userInterfaceStyle == .light ? Custom.tealColor : Custom.extraLightTeal
        }
    }
}



