//
//  ViewModel.swift
//  Home
//
//  Created by Joe Pan on 2025/3/5.
//

import Combine
import UIKit

final class ViewModel {
    @Published private(set) var state = State.none
    private(set) var currentIndex = 0
}

// MARK: - Internal

internal extension ViewModel {
    func doAction(_ action: Action) {
        switch action {
        case let .tap(request):
            actionTap(request: request)
        case let .swipe(request):
            actionSwipe(request: request)
        }
    }
}

// MARK: - Private

private extension ViewModel {
    // MARK: Handle Action
    
    func actionTap(request: TapRequest) {
        if request.index > request.maxCount - 1 {
            return
        }
        
        if currentIndex == request.index {
            return
        }
        
        let response = TapResponse(
            index: request.index,
            direction: request.index > currentIndex ? .forward : .reverse
        )
        
        state = .tap(response: response)
        currentIndex = request.index
    }
    
    func actionSwipe(request: SwipeRequest) {
        if request.index > request.maxCount - 1 {
            return
        }
        
        if currentIndex == request.index {
            return
        }
        
        currentIndex = request.index
        let response = SwipeResponse(index: currentIndex)
        state = .swipe(response: response)
    }
}
