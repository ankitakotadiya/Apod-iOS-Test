import SwiftUI

struct MediaContentView: View {
    var mediaURL: URL?
    var mediaType: MediaType
    var maxWidth: CGFloat
    var maxHeightFactor: CGFloat
    @Binding var selectedImage: Image?
    @Binding var gifImageTapped: Bool?
    @ScaledMetric(relativeTo: .callout) private var imageWidth: CGFloat = 50
    
    var body: some View {
        Group {
            if let _url = mediaURL {
                loadMedia(for: mediaType, url: _url)
            } else {
                fallbackImage
            }
        }
        .accessibilityIdentifier(Identifiers.Apod.mediaContentView)
        .frame(width: maxWidth, height: maxHeightFactor)
        .clipped()
    }
}

// View extension methods
extension MediaContentView {
    private func loadMedia(for type: MediaType, url: URL) -> some View {
        Group {
            switch type {
            case .image:
                loadImage(_url: url) // Load image if media type is image
            case .video:
                loadVideo(_url: url) // Load video if media type is video
            case .gif:
                loadGif(_url: url) // Load GIF if media type is gif
            case .other:
                fallbackImage // Return fallback if media type is 'other'
            }
        }
    }
    
    private var fallbackImage: some View {
        CustomImage(
            .system,
            name: Images.failedImage,
            width: imageWidth,
            height: imageWidth
        )
    }
    
    // Load an image from the given URL
    private func loadImage(_url: URL?) -> some View {
        AsyncImageView(url: _url) { downloadedImage in
            downloadedImage
                .resizable()
                .scaledToFill()
                .accessibilityIdentifier(Identifiers.Apod.apodImage)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedImage = downloadedImage
                    }
                }
        }
    }
    
    // Load a video from the given URL
    private func loadVideo(_url: URL?) -> some View {
        WebView(url: _url)
    }
    
    // Load a GIF from the given URL
    private func loadGif(_url: URL?) -> some View {
        AnimatedGifImageView(url: _url)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    gifImageTapped = true
                }
            }
    }
}

//#Preview {
//    MediaContentView()
//}
