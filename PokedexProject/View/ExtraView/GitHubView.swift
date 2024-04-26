//
//  GitHubView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/26/24.
//

import SwiftUI
import WebKit

struct GitHubView: View {
    var body: some View {
        WebViewRepresentable()
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView: WKWebView = WKWebView()
        guard let requestURL: URL = URL(string: "https://github.com/hellotunamayo/PokeDexProject") else { return WKWebView() }
        let request: URLRequest = URLRequest(url: requestURL)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    typealias UIViewType = WKWebView
}

#Preview {
    GitHubView()
}
