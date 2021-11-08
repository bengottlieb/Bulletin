//
//  ContentView.swift
//  Bulletin
//
//  Created by Ben Gottlieb on 11/7/21.
//

import SwiftUI

struct ContentView: View {
	@StateObject var bulletin = Bulletin(file: "bulletin.html")
	@State var isVisible = true
	
	var body: some View {
		ZStack() {
			Rectangle()
			
			Image("sample_background")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.edgesIgnoringSafeArea(.all)
				.layoutPriority(-1)
			
			VStack() {
				Button(isVisible ? "Hide" : "Show") {
					withAnimation { isVisible.toggle() }
				}
				.foregroundColor(.white)
				.font(.system(size: 40))
				.disabled(bulletin.loadingState != .loaded)
				
				if bulletin.webView.isLoading {
					ProgressView()
						.frame(width: 60)
				}
			}
			
			BulletinView(bulletin: bulletin)
				.padding(20)
				.placement(.middle(0.8), for: bulletin, isVisible: $isVisible)
		}
		.onReceive(bulletin.message) { message in
			if message == "done" { withAnimation { isVisible = false } }
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
