//
//  MainVC.swift
//
//  Created by Shinren Pan on 2024/4/3.
//

import Combine
import UIKit

final class MainVC: UIViewController {
    private let vo = MainVO()
    private let vm = MainVM()
    private let router = MainRouter()
    private var binding: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelf()
        setupBinding()
        setupVO()
    }
}

// MARK: - Public

extension MainVC {}

// MARK: - Private

private extension MainVC {
    // MARK: Setup Something

    func setupSelf() {
        view.backgroundColor = vo.mainView.backgroundColor
        router.vc = self
    }

    func setupBinding() {
        vm.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
            if self?.viewIfLoaded?.window == nil { return }

            switch state {
            case .none:
                self?.stateNone()
            case .tabToPage:
                self?.stateTabToPage()
            case .swipeToPage:
                self?.stateSwipeToPage()
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
        vo.addPageContainer()
        vo.pageContainer.didMove(toParent: self)
        vo.pageContainer.dataSource = self
        vo.pageContainer.delegate = self
        
        vo.reloadUIWithTap(model: vm.model, animated: false)
        
        vo.tab.addTarget(self, action: #selector(tabClicked(_:)), for: .valueChanged)
    }

    // MARK: - Handle State

    func stateNone() {}
    
    func stateTabToPage() {
        vo.reloadUIWithTap(model: vm.model)
    }
    
    func stateSwipeToPage() {
        vo.reloadUIWithSwipe(model: vm.model)
    }
    
    // MARK: - Target / Action
    
    @objc func tabClicked(_ sender: MainTabSegment) {
        let nextIndex = sender.selectedSegmentIndex
        vm.doAction(.tabToPage(index: nextIndex))
    }
}

// MARK: - UIPageViewControllerDataSource

extension MainVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        vm.model.prevPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        vm.model.nextPage
    }
}

// MARK: - UIPageViewControllerDelegate

extension MainVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let vc = pageViewController.viewControllers?.first,
           let index = vm.model.pages.firstIndex(where: { $0 === vc }) {
            vm.doAction(.swipeToPage(index: index))
        }
    }
}
