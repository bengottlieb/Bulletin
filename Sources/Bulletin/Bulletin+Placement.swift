//
//  Bulletin+Placement.swift
//  Bulletin-TestHarness
//
//  Created by Ben Gottlieb on 11/7/21.
//

import SwiftUI

struct PlacedBulletinView<Content: View>: View {
    let content: Content
    @ObservedObject var bulletin: Bulletin
    @Binding var isVisible: Bool
    
    let placement: BulletinView.Placement
    let blockingColor: Color
    
    var showContent: Bool { isVisible && bulletin.hasLoadedOnce }
    
    var body: some View {
        GeometryReader() { geo in
            ZStack() {
                Rectangle()
                    .fill(showContent ? blockingColor : .clear)
                
                if isVisible {
                    ZStack() {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: placement.topSpacerHeight(in: geo))
                            
                            content
                            
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: placement.bottomSpacerHeight(in: geo))
                        }
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

public extension View {
    func placement( _ placement: BulletinView.Placement = .full, for bulletin: Bulletin, isVisible: Binding<Bool>, blockingColor: Color = Color(white: 0.1).opacity(0.5)) -> some View {
        
        PlacedBulletinView(content: self, bulletin: bulletin, isVisible: isVisible, placement: placement, blockingColor: blockingColor)
    }
}
