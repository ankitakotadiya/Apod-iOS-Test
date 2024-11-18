import SwiftUI

// Common class to display loading indicator across the app.
struct LoadingView: View {
    private var loadingWidth: CGFloat = 100
    
    var body: some View {
        ZStack {
            Color.System.tertiarySystemBackground
                .frame(width: loadingWidth, height: loadingWidth)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .foregroundStyle(.green)
                .scaleEffect(1.5)
                .dynamicTypeSize(...DynamicTypeSize.defaultSize)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityIdentifier(Identifiers.View.mainIndicator)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview {
//    LoadingView()
//}
