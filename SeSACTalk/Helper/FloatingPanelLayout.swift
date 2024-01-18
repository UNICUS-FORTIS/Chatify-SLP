//
//  OnboardingFloatingPanelLayout.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import Foundation
import FloatingPanel



final class OnboardingFloatingPanelLayout: FloatingPanelLayout {
    
    var position: FloatingPanel.FloatingPanelPosition = .bottom
    var initialState: FloatingPanel.FloatingPanelState = .full
    
    var anchors: [FloatingPanel.FloatingPanelState : FloatingPanel.FloatingPanelLayoutAnchoring] = [
        .full : FloatingPanelLayoutAnchor(absoluteInset: 290, edge: .bottom, referenceGuide: .superview)
    ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .full, .half: return 0.3
        default: return 0.0
        }
    }
}
