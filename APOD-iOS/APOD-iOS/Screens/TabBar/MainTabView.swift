import Foundation
import SwiftUI

enum AppTab: CaseIterable {
    case today
    case favourites
    
    // Tabbar titles
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .favourites:
            return "Favourites"
        }
    }
    
    // Tabbar icons
    var iconName: String {
        switch self {
        case .today:
            return "calendar"
        case .favourites:
            return "heart.fill"
        }
    }
    
    // Determines the view associated with each tab
    @ViewBuilder
    var view: some View {
        switch self {
        case .today:
            ApodView()
        case .favourites:
            FavouritesView()
        }
    }
}

struct MainTabView: View {
    // Accessing the current color scheme (light or dark mode)
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        TabView {
            ForEach(AppTab.allCases, id: \.self) { tab in
                
                tab.view
                
                    .tabItem {
                        Label(tab.title, systemImage: tab.iconName)
                    }
            }
        }
        .tint(colorScheme == .light ? Color.Custom.tealColor : Color.Custom.extraLightTeal)
    }
}
