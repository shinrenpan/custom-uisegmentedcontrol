//
//  Model.swift
//  Home
//
//  Created by Joe Pan on 2025/3/5.
//

import UIKit

enum Action {
    case tap(request: TapRequest)
    case swipe(request: SwipeRequest)
}

enum State {
    case none
    case tap(response: TapResponse)
    case swipe(response: SwipeResponse)
}

struct TapRequest {
    let index: Int
    let maxCount: Int
}

struct SwipeRequest {
    let index: Int
    let maxCount: Int
}

struct TapResponse {
    let index: Int
    let direction: UIPageViewController.NavigationDirection
}

struct SwipeResponse {
    let index: Int
}
