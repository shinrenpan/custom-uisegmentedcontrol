//
//  MainModels.swift
//
//  Created by Shinren Pan on 2024/4/3.
//

import UIKit

enum MainModels {}

// MARK: - Action

extension MainModels {
    enum Action {
        case tabToPage(index: Int)
        case swipeToPage(index: Int)
    }
}

// MARK: - State

extension MainModels {
    enum State {
        case none
        case tabToPage
        case swipeToPage
    }
}

// MARK: - Other Model for DisplayModel

extension MainModels {}

// MARK: - Display Model for ViewModel

extension MainModels {
    final class DisplayModel {
        var currentIndex = 0
        var direction = UIPageViewController.NavigationDirection.forward
        
        let pages: [UIViewController] = [
            PageVC(color: .red),
            PageVC(color: .green),
            PageVC(color: .orange),
        ]
        
        var currentPage: UIViewController {
            pages[currentIndex]
        }
        
        var prevPage: UIViewController? {
            if currentIndex - 1 < 0 {
                return nil
            }
            
            return pages[currentIndex - 1]
        }
        
        var nextPage: UIViewController? {
            if currentIndex + 1 >= pages.count {
                return nil
            }
            
            return pages[currentIndex + 1]
        }
        
        func reloadIndexSuccess(nextIndex: Int) -> Bool {
            if nextIndex == currentIndex {
                return false
            }
            
            direction = nextIndex > currentIndex ? .forward : .reverse
            currentIndex = nextIndex
            
            return true
        }
    }
}
