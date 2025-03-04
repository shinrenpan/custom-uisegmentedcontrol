//
//  ViewController.swift
//  Home
//
//  Created by Joe Pan on 2025/3/5.
//

import Combine
import UIKit

public final class ViewController: UIViewController {
    private let vo = ViewOutlet()
    private let vm = ViewModel()
    private let router = Router()
    private var binding: Set<AnyCancellable> = .init()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupSelf()
        setupBinding()
        setupVO()
    }
}

// MARK: - Private

private extension ViewController {
    func setupSelf() {
        view.backgroundColor = vo.mainView.backgroundColor
        router.vc = self
    }

    func setupBinding() {
        vm.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
            guard let self else { return }
            if viewIfLoaded?.window == nil { return }

            switch state {
            case .none:
                stateNone()
            case let .tap(response):
                stateTap(response: response)
            case let .swipe(response):
                stateSwipe(response: response)
            }
        }.store(in: &binding)
    }

    func setupVO() {
        view.addSubview(vo.mainView)

        NSLayoutConstraint.activate([
            vo.mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vo.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            vo.mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            vo.mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        addChild(vo.pageContainer)
        vo.reloadPageContainer()
        vo.pageContainer.didMove(toParent: self)
        vo.pageContainer.dataSource = self
        vo.pageContainer.delegate = self
        vo.reloadUIWithTap(response: .init(index: 0, direction: .forward), animated: false)
        
        vo.tabView.addAction(.init() { [weak self] _ in
            guard let self else { return }
            let index = vo.tabView.selectedSegmentIndex
            let maxCount = vo.pages.count
            let request = TapRequest(index: index, maxCount: maxCount)
            vm.doAction(.tap(request: request))
        }, for: .valueChanged)
    }

    func stateNone() {}
    
    func stateTap(response: TapResponse) {
        vo.reloadUIWithTap(response: response, animated: true)
    }
    
    func stateSwipe(response: SwipeResponse) {
        vo.reloadUIWithSwipe(response: response)
    }
    
    func makePrevViewController() -> UIViewController? {
        let prevIndex = vm.currentIndex - 1
        
        if prevIndex < 0 {
            return nil
        }
        
        if prevIndex > vo.pages.count - 1 {
            return nil
        }
        
        return vo.pages[prevIndex]
    }
    
    func makeNextViewController() -> UIViewController? {
        let nextIndex = vm.currentIndex + 1
        
        if nextIndex > vo.pages.count - 1 {
            return nil
        }
        
        return vo.pages[nextIndex]
    }
    
    func getCurrentPageIndex(pageViewController: UIPageViewController) -> Int? {
        guard let currentVC = pageViewController.viewControllers?.first else {
            return nil
        }
        
        return vo.pages.firstIndex(where: { $0 === currentVC })
    }
}

// MARK: - UIPageViewControllerDataSource

extension ViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        makePrevViewController()
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        makeNextViewController()
    }
}

// MARK: - UIPageViewControllerDelegate

extension ViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentIndex = getCurrentPageIndex(pageViewController: pageViewController) {
            let maxCount = vo.pages.count
            let request = SwipeRequest(index: currentIndex, maxCount: maxCount)
            vm.doAction(.swipe(request: request))
        }
    }
}
