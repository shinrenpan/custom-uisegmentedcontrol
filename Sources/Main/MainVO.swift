//
//  MainVO.swift
//
//  Created by Shinren Pan on 2024/4/3.
//

import UIKit

@MainActor final class MainVO {
    let mainView = UIView(frame: .zero)
    lazy var tabView = makeTabView()
    lazy var pages = makePages()
    lazy var pageContainer = makePageContainer()
    
    init() {
        setupSelf()
        addViews()
    }
}

// MARK: - Public

extension MainVO {
    func reloadPageContainer() {
        if pageContainer.view.superview === mainView {
            return
        }
        
        mainView.addSubview(pageContainer.view)
        
        NSLayoutConstraint.activate([
            pageContainer.view.topAnchor.constraint(equalTo: tabView.bottomAnchor),
            pageContainer.view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            pageContainer.view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            pageContainer.view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
        ])
    }
    
    func reloadUIWithTap(response: MainModel.TapResponse, animated: Bool = true) {
        let vc = pages[response.index]
        pageContainer.setViewControllers([vc], direction: response.direction, animated: animated)
    }
    
    func reloadUIWithSwipe(response: MainModel.SwipeResponse) {
        tabView.selectedSegmentIndex = response.index
    }
}

// MARK: - Private

private extension MainVO {
    // MARK: Setup Something
    
    func setupSelf() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        tabView.translatesAutoresizingMaskIntoConstraints = false
        pageContainer.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Add Something
    
    func addViews() {
        mainView.addSubview(tabView)

        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: mainView.topAnchor),
            tabView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tabView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    // MARK: - Make Something
    
    func makePages() -> [UIViewController] {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .red
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .green
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .yellow
        
        return [vc1, vc2, vc3]
    }
    
    func makePageContainer() -> UIPageViewController {
        .init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    func makeTabView() -> CustomTabView {
        let configuration = CustomTabView.Configuration(
            selectedFont: .boldSystemFont(ofSize: 20),
            unselectedFont: .systemFont(ofSize: 18),
            selectedTextColor: .systemBlue,
            unselectedTextColor: .darkText,
            indicatorColor: .systemBlue
        )
        
        let result = CustomTabView(titles: ["Red", "Green", "Yellow"], configuration: configuration)
        result.selectedSegmentIndex = 0
        
        return result
    }
}
