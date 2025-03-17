//
//  ProgressRingViewModel.swift
//  Mytask
//
//  Created by Vineet Rai on 16-Mar-25.
//

import CoreData
import SwiftUI

class ProgressRingViewModel: ObservableObject {
    @Published var isProgressInNavBar = false // Track if progress ring is in nav bar
    @Published var dragOffset: CGFloat = 0 // Track drag translation
    @Published var dragProgress: CGFloat = 0 // Track drag progress (0 to 1)
    
    // Constants
    private let dragThreshold: CGFloat = 100 // Distance to trigger transition
    private let maxOffset: CGFloat = 200 // Maximum offset for the progress ring

    func dragOffsetCalculationOnGestureChange(value: DragGesture.Value) {
        dragOffset = min(max(value.translation.height, -maxOffset), 0)
           dragProgress = min(abs(dragOffset) / dragThreshold, 1)
    }

    func draOnEnd(value: DragGesture.Value) {
        // Snap to toolbar if drag exceeds threshold
        if abs(value.translation.height) > dragThreshold {
            withAnimation(.easeInOut(duration: 0.3)) {
                isProgressInNavBar = true
                dragOffset = 0
                dragProgress = 1
            }
        } else {
            // Return to main content
            withAnimation(.easeInOut(duration: 0.3)) {
                dragOffset = 0
                dragProgress = 0
            }
        }
    }
}
