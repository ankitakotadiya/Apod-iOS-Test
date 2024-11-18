import SwiftUI

@main
struct APOD_iOSApp: App {
    
    init() {
        configureNavigationBarAppearance()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    // Private function to configure the navigation bar's appearance
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.navigationColor]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.navigationColor
        ]
        // Apply the appearance globally
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.navigationColor
    }
}
