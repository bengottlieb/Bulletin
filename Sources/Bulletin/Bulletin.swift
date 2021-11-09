//
//  Bulletin.swift
//  Bulletin-TestHarness
//
//  Created by Ben Gottlieb on 11/7/21.
//

import WebKit
import Suite

public class Bulletin: NSObject, ObservableObject, WKNavigationDelegate {
	let url: URL?
	let html: String?
	var webView: WKWebView!
    var disabledScrolling = true
	var currentNavigation: WKNavigation?
	@Published public var hasLoadedOnce = false
	@Published public var loadingState: LoadingState = .notLoaded
	public var message = CurrentValueSubject<String?, Never>(nil)
	
	public enum LoadingState: Equatable { case notLoaded, inProgress, loaded, failed(Error)
		public static func ==(lhs: LoadingState, rhs: LoadingState) -> Bool {
			switch (lhs, rhs) {
			case (.notLoaded, .notLoaded): return true
			case (.loaded, .loaded): return true
			case (.inProgress, .inProgress): return true
			default: return false
			}
		}
	}
	
    public init(url: URL? = nil, html: String? = nil, file: String? = nil, disableScrolling: Bool = true) {
		if let filename = file {
			self.url = Bundle.main.url(forResource: filename, withExtension: nil)
		} else {
			self.url = url
		}
		self.html = html
        self.disabledScrolling = disableScrolling
		super.init()
		webView = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
		
		webView.navigationDelegate = self
		currentNavigation = webView.load(self)
	}
	
    func loadFinished() {
        updateScrolling()
    }
    
    func updateScrolling() {
        if disabledScrolling, webView.scrollView.contentSize.height <= webView.bounds.height {
            webView.scrollView.isScrollEnabled = false
        } else {
            webView.scrollView.isScrollEnabled = true
        }
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
	
	var configuration: WKWebViewConfiguration {
		let config = WKWebViewConfiguration()
		config.userContentController = WKUserContentController()
		config.userContentController.add(self, name: "postBulletinEvent")
		
		let postScript = WKUserScript(source: "function postBulletinEvent(event) { window.webkit.messageHandlers.postBulletinEvent.postMessage(event); }", injectionTime: .atDocumentEnd, forMainFrameOnly: false)
		config.userContentController.addUserScript(postScript)
		
		return config
	}
	
	static let sample = Bulletin(url: URL(string: "https://daringfireball.net"))
}

extension Bulletin: WKScriptMessageHandler {
	public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		self.message.send(message.body as? String)
	}
}
