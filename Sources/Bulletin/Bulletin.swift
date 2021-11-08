//
//  Bulletin.swift
//  Bulletin-TestHarness
//
//  Created by Ben Gottlieb on 11/7/21.
//

import Foundation
import WebKit
import SwiftUI

public class Bulletin: NSObject, ObservableObject, WKNavigationDelegate {
	let url: URL?
	let html: String?
	let webView: WKWebView
	var currentNavigation: WKNavigation?
    @Published var hasLoadedOnce = false
	@Published var loadingState: LoadingState = .notLoaded

	enum LoadingState: Equatable { case notLoaded, inProgress, loaded, failed(Error)
		static func ==(lhs: LoadingState, rhs: LoadingState) -> Bool {
			switch (lhs, rhs) {
			case (.notLoaded, .notLoaded): return true
			case (.loaded, .loaded): return true
			case (.inProgress, .inProgress): return true
			default: return false
			}
		}
	}

	public init(url: URL? = nil, html: String? = nil) {
		self.url = url
		self.html = html
		
		let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
		
		super.init()
		webView.navigationDelegate = self
		currentNavigation = webView.load(self)
	}

	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		withAnimation {
            hasLoadedOnce = true
            loadingState = .loaded
        }
	}
	
	public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		withAnimation { loadingState = .failed(error) }
	}
	
	public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		withAnimation { loadingState = .inProgress }
	}

	static let sample = Bulletin(url: URL(string: "https://daringfireball.net"))
}
