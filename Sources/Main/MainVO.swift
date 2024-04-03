//
//  MainVO.swift
//
//  Created by Shinren Pan on 2024/4/3.
//

import UIKit

final class MainVO {
    let mainView = UIView(frame: .zero)
    let tab = MainTabSegment(titles: ["Tab1", "Tab2", "Tab3"])
    let pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    init() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        tab.translatesAutoresizingMaskIntoConstraints = false
        pageContainer.view.translatesAutoresizingMaskIntoConstraints = false
        addViews()
    }
}

// MARK: - Public

extension MainVO {
    func addPageContainer() {
        if pageContainer.view.superview === mainView {
            return
        }
        
        mainView.addSubview(pageContainer.view)
        NSLayoutConstraint.activate([
            pageContainer.view.topAnchor.constraint(equalTo: tab.bottomAnchor),
            pageContainer.view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            pageContainer.view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            pageContainer.view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
        ])
    }
    
    func reloadUIWithTap(model: MainModels.DisplayModel, animated: Bool = true) {
        pageContainer.setViewControllers([model.currentPage], direction: model.direction, animated: animated)
    }
    
    func reloadUIWithSwipe(model: MainModels.DisplayModel) {
        tab.selectedSegmentIndex = model.currentIndex
    }
}

// MARK: - Private

private extension MainVO {
    // MARK: Add Something
    
    func addViews() {
        mainView.addSubview(tab)
        NSLayoutConstraint.activate([
            tab.topAnchor.constraint(equalTo: mainView.topAnchor),
            tab.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tab.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            tab.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
