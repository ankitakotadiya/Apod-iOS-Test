import SwiftUI

struct CustomImage: View {
    enum ImageType {
        case custom
        case system
    }
    private let type: ImageType
    private let name: String
    private let width: CGFloat
    private let height: CGFloat
    
    init(_ type: ImageType, name: String, width: CGFloat, height: CGFloat) {
        self.name = name
        self.width = width
        self.height = height
        self.type = type
    }
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
    }
    
    private var image: Image {
        switch type {
        case .custom:
            return Image(name)
        case .system:
            return Image(systemName: name)
        }
    }
}
