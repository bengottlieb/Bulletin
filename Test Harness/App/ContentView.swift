//
//  ContentView.swift
//  Bulletin
//
//  Created by Ben Gottlieb on 11/7/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		 ZStack() {
			 Image("sample_background")
				 .resizable()
				 .aspectRatio(contentMode: .fill)
				 .edgesIgnoringSafeArea(.all)
				 .layoutPriority(-1)
			 
			 BulletinView(kind: .middle(0.8), bulletin: .sample, padding: EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
		 }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
