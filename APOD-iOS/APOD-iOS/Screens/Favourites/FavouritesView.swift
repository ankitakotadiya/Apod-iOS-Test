import SwiftUI

// Coming Soon view
struct FavouritesView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Coming Soon...")
                    .font(.title3)
                    .dynamicTypeSize(DynamicTypeSize.customDeviceSize)
            }
            .navigationTitle("Favourites")
        }
    }
}

//#Preview {
//    FavouritesView()
//}
