//
//  BulletinWebView.swift
//  Bulletin-TestHarness
//
//  Created by Ben Gottlieb on 11/7/21.
//

import SwiftUI
import WebKit

struct BulletinWebView: UIViewRepresentable {
	typealias UIViewType = WKWebView
	
	let bulletin: Bulletin

	func makeUIView(context: Context) -> WKWebView {
		bulletin.webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(bulletin: bulletin)
	}
	
	class Coordinator: NSObject, WKNavigationDelegate {
		let bulletin: Bulletin
		
		init(bulletin: Bulletin) {
			self.bulletin = bulletin
			super.init()
			
		}
		
	}
}

struct BulletinWebView_Previews: PreviewProvider {
	static var previews: some View {
		BulletinWebView(bulletin: .sample)
	}
}
