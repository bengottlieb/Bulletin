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
    @State var dragOffset = 0.0
    @State var contentSize = CGSize.zero
    
    let placement: BulletinView.Placement
    let blockingColor: Color
    
    var showContent: Bool { isVisible && bulletin.hasLoadedOnce }
    
    var body: some View {
        GeometryReader() { geo in
            ZStack() {
                Rectangle()
                    .fill(showContent ? blockingColor : .clear)
                
                if showContent {
                    ZStack() {
                        
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: placement.topSpacerHeight(in: geo))
                            
                            ZStack() {
                                content
                                    .sizeReporting($contentSize)
                                    .onAppear {
                                        DispatchQueue.main.async(after: 0.25) { bulletin.updateScrolling() }
                                    }
                            }
                            
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: placement.bottomSpacerHeight(in: geo))
                        }
                    }
                    .offset(y: dragOffset)
                    .gesture(DragGesture(minimumDistance: 10).onChanged { value in
                        dragOffset = max(value.translation.height, 0)
                    }.onEnded { gesture in
                        let duration: TimeInterval = 0.2
                        if gesture.predictedEndTranslation.height > UIScreen.main.bounds.height / 2 {
                            withAnimation(.easeOut(duration: duration)) { dragOffset = UIScreen.main.bounds.height }
                            DispatchQueue.main.async(after: duration) {
                                isVisible = false
                                dragOffset = 0
                            }
                        } else {
                            withAnimation(.easeOut(duration: duration)) { dragOffset = 0 }
                        }
                    })
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
