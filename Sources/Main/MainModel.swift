//
//  MainModel.swift
//
//  Created by Shinren Pan on 2024/4/3.
//

import UIKit

enum MainModel {}

// MARK: - Action

extension MainModel {
    enum Action {
        case tap(request: TapRequest)
        case swipe(request: SwipeRequest)
    }
    
    struct TapRequest {
        let index: Int
        let maxCount: Int
    }
    
    struct SwipeRequest {
        let index: Int
        let maxCount: Int
    }
}

// MARK: - State

extension MainModel {
    enum State {
        case none
        case tap(response: TapResponse)
        case swipe(response: SwipeResponse)
    }
    
    struct TapResponse {
        let index: Int
        let direction: UIPageViewController.NavigationDirection
    }
    
    struct SwipeResponse {
        let index: Int
    }
}
