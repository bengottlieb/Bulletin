//
//  BulletinView+Enums.swift
//  Bulletin-TestHarness
//
//  Created by Ben Gottlieb on 11/7/21.
//

import SwiftUI

extension BulletinView {
    public enum Placement: Equatable { case full, middle(Double), bottom(Double)
        public static func ==(lhs: Placement, rhs: Placement) -> Bool {
            switch (lhs, rhs) {
            case (.full, .full): return true
            case (.middle(let left), .middle(let right)): return left == right
            case (.bottom(let left), .bottom(let right)): return left == right
            default: return false
            }
        }
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
    
    public enum CloseMethod { case none, leadingX, trailingX, leadingChevronDown, trailingChevronDown, chevronBack
        
        @ViewBuilder var closeView: some View {
            switch self {
            default: EmptyView()
            }
        }
    }
}
