//
//  BulletinView.swift
//  Bulletin-TestHarness
//
//  Created by Ben Gottlieb on 11/7/21.
//

import SwiftUI

public struct BulletinView: View {
	@ObservedObject var bulletin: Bulletin
	let kind: Kind
	let overlayColor: Color
	let edgeInsets: EdgeInsets
	
	public enum Kind { case full, middle(Double), bottom(Double)
		func topSpacerHeight(in geo: GeometryProxy) -> Double {
			switch self {
			case .full: return 0
			case .middle(let percent): return (1.0 - percent) * geo.size.height * 0.5
			case .bottom(let percent): return (1.0 - percent) * geo.size.height
			}
		}

		func bottomSpacerHeight(in geo: GeometryProxy) -> Double {
			switch self {
			case .full: return 0
			case .middle(let percent): return (1.0 - percent) * geo.size.height * 0.5
			case .bottom(_): return 0
			}
		}
	}
	
	init(kind: Kind, bulletin: Bulletin, overlayColor: Color = Color(white: 0.1).opacity(0.5), padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) {
		self.kind = kind
		self.bulletin = bulletin
		self.overlayColor = overlayColor
		self.edgeInsets = padding
	}
	
	public var body: some View {
		Group() {
			if bulletin.loadingState == .loaded {
				GeometryReader() { geo in
					ZStack() {
						Rectangle()
							.fill(overlayColor)
						
						VStack(spacing: 0) {
							Rectangle()
								.fill(Color.clear)
								.frame(height: kind.topSpacerHeight(in: geo))

							bulletinView

							Rectangle()
								.fill(Color.clear)
								.frame(height: kind.bottomSpacerHeight(in: geo))
						}
						.padding(edgeInsets)
					}
				}
				.edgesIgnoringSafeArea(.all)
			}
		}
		.transition(.move(edge: .bottom))
	}
	
	@ViewBuilder var bulletinView: some View {
		switch kind {
		case .full:
			BulletinContentView(bulletin: bulletin)
			
		default:
			BulletinContentView(bulletin: bulletin)
				.clipShape(RoundedRectangle(cornerRadius: 20))
		}
	}
}

struct BulletinView_Previews: PreviewProvider {
	static var previews: some View {
		BulletinView(kind: .bottom(0.75), bulletin: .sample)
	}
}
