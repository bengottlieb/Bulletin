//
//  BulletinContentView.swift
//  Bulletin-TestHarness
//
//  Created by Ben Gottlieb on 11/7/21.
//

import SwiftUI

struct BulletinContentView: View {
	let bulletin: Bulletin
	
	var body: some View {
		BulletinWebView(bulletin: bulletin)
	}
}

struct BulletinContentView_Previews: PreviewProvider {
	static var previews: some View {
		BulletinContentView(bulletin: .sample)
	}
}
