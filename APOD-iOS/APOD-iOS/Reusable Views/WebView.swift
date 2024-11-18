import SwiftUI
import WebKit

// This WebView struct is a SwiftUI UIViewRepresentable that wraps a WKWebView to load and display web content from a given URL.
struct WebView: UIViewRepresentable {
    var url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let _url = url else { return }
        
        let request = URLRequest(url: _url)
        uiView.load(request)
    }
}


