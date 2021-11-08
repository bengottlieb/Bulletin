//
//  BulletinView.swift
//  Bulletin-TestHarness
//
//  Created by Ben Gottlieb on 11/7/21.
//

import SwiftUI

public struct BulletinView: View {
	@ObservedObject var bulletin: Bulletin
	
    init(bulletin: Bulletin) {
        self.bulletin = bulletin
	}
	
	public var body: some View {
        BulletinContentView(bulletin: bulletin)
            .clipShape(RoundedRectangle(cornerRadius: 20))
	}
}

