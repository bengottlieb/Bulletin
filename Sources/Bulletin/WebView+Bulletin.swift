//
//  WebView+Bulletin.swift
//  Bulletin-TestHarness
//
//  Created by Ben Gottlieb on 11/7/21.
//

import Foundation
import WebKit

extension WKWebView {
	@discardableResult func load(_ bulletin: Bulletin) -> WKNavigation? {
		if let url = bulletin.url {
			if url.isFileURL {
				return loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
			} else {
				return load(URLRequest(url: url))
			}
		} else if let html = bulletin.html {
			return loadHTMLString(html, baseURL: Bundle.main.resourceURL)
		}
		return nil
	}
}
