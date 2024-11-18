import SwiftUI
import SwiftData

struct ApodView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var viewModel: ApodViewModel = ApodViewModel()
    @State private var selectedDate: Date = Date.now
    @State var selectedImage: Image? = nil
    @State var gifTapped: Bool?
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    if let apod = viewModel.state.apod { // Once response is received
                        ScrollView {
                            VStack(alignment: .leading,
                                   content: {
                                // Image/Video/Gif
                                MediaContentView(
                                    mediaURL: apod.url,
                                    mediaType: apod.mediaType,
                                    maxWidth: geometry.size.width,
                                    maxHeightFactor: geometry.size.height * 0.55,
                                    selectedImage: $selectedImage,
                                    gifImageTapped: $gifTapped
                                )
                                // Title & Explanation
                                description
                                Spacer()
                            })
                        }
                    }
                    
                    // ProgressView
                    if case .loading = viewModel.state {
                        LoadingView()
                    }
                    
                    // Full Screen Image
                    if selectedImage != nil {
                        fullScreenView(geometry)
                            .onTapGesture {
                                self.selectedImage = nil
                            }
                    }
                    
                    // Full Screen Gif
                    if gifTapped != nil {
                        fullScreenView(geometry)
                            .onTapGesture {
                                self.gifTapped = nil
                            }
                    }
                }
            }
            .navigationTitle(Identifiers.Apod.navTitle)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    datePicker // Right bar button item
                }
            })
        }
        .onChange(of: selectedDate, perform: { value in
            loadData(for: value) // Load data when date change
        })
        .onAppear(perform: {
            loadData(for: selectedDate) // Load APOD for `Today`
        })
        .onDisappear {
            Task(priority: .background) {
                await viewModel.cleanUpResource()
            }
        }
    }
}

// Api Extension
extension ApodView {
    private func loadData(for date: Date) {
        Task {
            await viewModel.load(strDate: viewModel.dateFormatting.stringFromDate(date: date))
        }
    }
}

// View Extensions
extension ApodView {
    // Fullscreen View to display Image/Gif
    private func fullScreenView(_ geometry: GeometryProxy) -> some View {
        ZStack {
            Color.black
            
            if let selectedImage = selectedImage {
                fullScreenImageContent(selectedImage, geometry: geometry)
            } else if gifTapped != nil {
                fullScreenGifContent()
            }
        }
        .accessibilityIdentifier(Identifiers.Apod.fullScreenView)
    }
    
    // Fullscreen Image
    private func fullScreenImageContent(_ image: Image, geometry: GeometryProxy) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: geometry.size.width - 20, height: geometry.size.height)
    }
    
    // Fullscreen GIF
    private func fullScreenGifContent() -> some View {
        AnimatedGifImageView(url: viewModel.state.apod?.url)
            .scaledToFit()
    }
    
    // Title and Explanation
    private var description: some View {
        Group {
            // Apod Title
            Text(viewModel.state.apod?.title ?? "")
                .font(.title2)
                .fontWeight(.semibold)
                .dynamicTypeSize(DynamicTypeSize.customDeviceSize)
                .lineLimit(3)
                .minimumScaleFactor(0.9)
           
            // Apod Explanation
            Text(viewModel.state.apod?.explanation ?? "")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundStyle(colorScheme == .light ? Color.Custom.charcol : .white)
                .padding(.vertical, 5)
                .dynamicTypeSize(DynamicTypeSize.customDeviceSize)
        }
        .padding(.horizontal)
    }
    
    // Date Picker
    private var datePicker: some View {
        let apodDate = viewModel.dateFormatting.dateFromString(Defautls.apodStartDate)
        return DatePicker("", selection: $selectedDate, in: apodDate...Date(), displayedComponents: .date)
            .labelsHidden()
            .datePickerStyle(.compact)
            .accessibilityIdentifier(Identifiers.Apod.datePicker)
    }
}

 
