//
//  MainVM.swift
//
//  Created by Shinren Pan on 2024/4/3.
//

import Combine
import UIKit

final class MainVM {
    @Published private(set) var state = MainModel.State.none
    private(set) var currentIndex = 0
}

// MARK: - Public

extension MainVM {
    func doAction(_ action: MainModel.Action) {
        switch action {
        case let .tap(request):
            actionTap(request: request)
        case let .swipe(request):
            actionSwipe(request: request)
        }
    }
}

// MARK: - Private

private extension MainVM {
    // MARK: Handle Action
    
    func actionTap(request: MainModel.TapRequest) {
        if request.index > request.maxCount - 1 {
            return
        }
        
        if currentIndex == request.index {
            return
        }
        
        let response = MainModel.TapResponse(
            index: request.index,
            direction: request.index > currentIndex ? .forward : .reverse
        )
        
        state = .tap(response: response)
        currentIndex = request.index
    }
    
    func actionSwipe(request: MainModel.SwipeRequest) {
        if request.index > request.maxCount - 1 {
            return
        }
        
        if currentIndex == request.index {
            return
        }
        
        currentIndex = request.index
        let response = MainModel.SwipeResponse(index: currentIndex)
        state = .swipe(response: response)
    }
}
