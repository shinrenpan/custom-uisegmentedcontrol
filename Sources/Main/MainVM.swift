//
//  MainVM.swift
//
//  Created by Shinren Pan on 2024/4/3.
//

import Combine
import UIKit

final class MainVM {
    @Published private(set) var state = MainModels.State.none
    private(set) var model = MainModels.DisplayModel()
}

// MARK: - Public

extension MainVM {
    func doAction(_ action: MainModels.Action) {
        switch action {
        case let .tabToPage(index):
            actionTapToPage(index: index)
        case let .swipeToPage(index):
            actionSwipeToPage(index: index)
        }
    }
}

// MARK: - Private

private extension MainVM {
    // MARK: Handle Action
    
    func actionTapToPage(index: Int) {
        if model.reloadIndexSuccess(nextIndex: index) {
            state = .tabToPage
        }
    }
    
    func actionSwipeToPage(index: Int) {
        if model.reloadIndexSuccess(nextIndex: index) {
            state = .swipeToPage
        }
    }
}
