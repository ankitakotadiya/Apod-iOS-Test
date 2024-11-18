import SwiftUI

// View that asynchronously loads an image from a URL and displays it with custom content.
struct AsyncImageView<Content: View>: View {
    
    let url: URL?
    let imageContent: (Image) -> Content
    @ScaledMetric(relativeTo: .callout) private var imageWidth: CGFloat = 50
    
    init(
        url: URL?,
        @ViewBuilder imageContent: @escaping (Image) -> Content
    ) {
        self.url = url
        self.imageContent = imageContent
    }
    
    var body: some View {
        
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .dynamicTypeSize(...DynamicTypeSize.defaultSize)
                    .accessibilityIdentifier(Identifiers.View.imageIndicator)
            case .success(let image):
                imageContent(image)
            case .failure:
                CustomImage(
                    .system,
                    name: Images.failedImage,
                    width: imageWidth,
                    height: imageWidth
                )
            @unknown default:
                EmptyView()
            }
        }
    }
}

//#Preview {
//    AsyncImageView()
//}
