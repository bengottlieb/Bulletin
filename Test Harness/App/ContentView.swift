//
//  ContentView.swift
//  Bulletin
//
//  Created by Ben Gottlieb on 11/7/21.
//

import SwiftUI

let staticBulletin = Bulletin(url: URL(string: "https://daringfireball.net"))

struct ContentView: View {
    @ObservedObject var bulletin = staticBulletin
    @State var isVisible = false
    
    var body: some View {
		 ZStack() {
             Rectangle()
             
			 Image("sample_background")
				 .resizable()
				 .aspectRatio(contentMode: .fill)
				 .edgesIgnoringSafeArea(.all)
				 .layoutPriority(-1)
             
             VStack() {
                 Button("Show") {
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
                 .placement(.middle(0.8), for: bulletin, isVisible: $isVisible, blockingColor: .green.opacity(0.25))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
