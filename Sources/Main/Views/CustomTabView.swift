//
//  CustomTabView.swift
//
//  Created by Joe Pan on 2024/9/19.
//
//

import UIKit

final class CustomTabView: UISegmentedControl {
    let configuration: Configuration
    private lazy var indicator = makeIndicator()
    private var firstInit = true

    init(titles: [String], configuration: Configuration) {
        self.configuration = configuration
        super.init(items: titles)
        setupSelf()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        updateUI()
        
        // workaround label 字體縮小
        _ = subviews.compactMap { $0.subviews.compactMap {
            if let label = $0 as? UILabel {
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.5
            }
        }}
    }
}

// MARK: - Configuration

extension CustomTabView {
    struct Configuration {
        let selectedFont: UIFont
        let unselectedFont: UIFont
        let selectedTextColor: UIColor
        let unselectedTextColor: UIColor
        let indicatorColor: UIColor?
    }
}

// MARK: - Public

extension CustomTabView {
    func reloadTitles(_ titles: [String]) {
        if titles.isEmpty {
            return
        }
        
        var currentIndex = selectedSegmentIndex

        if currentIndex > titles.count - 1 {
            currentIndex = 0
        }

        removeAllSegments()

        for (idx, title) in titles.enumerated() {
            insertSegment(withTitle: title, at: idx, animated: false)
        }

        selectedSegmentIndex = currentIndex
    }
}

// MARK: - Private

private extension CustomTabView {
    
    // MARK: Setup Something
    
    func setupSelf() {
        setTitleTextAttributes([
            .font: configuration.unselectedFont,
            .foregroundColor: configuration.unselectedTextColor,
        ], for: .normal)

        setTitleTextAttributes([
            .font: configuration.selectedFont,
            .foregroundColor: configuration.selectedTextColor,
        ], for: .selected)

        selectedSegmentTintColor = .clear
        apportionsSegmentWidthsByContent = true

        // 移除分隔線
        setBackgroundImage(.init(), for: .normal, barMetrics: .default)
        setDividerImage(.init(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        if let indicator {
            addSubview(indicator)
        }
    }

    // MARK: - Reload Something
    
    func updateUI() {
        if subviews.isEmpty {
            return
        }
        
        guard let indicator else {
            return
        }
        
        let centerX = subviews[selectedSegmentIndex].center.x
        let width = frame.width / CGFloat(numberOfSegments)
        let height = 2.0
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let duration = firstInit ? 0.0 : 0.2
        firstInit = false
        
        UIView.animate(withDuration: duration) {
            indicator.frame = frame
            indicator.center = .init(x: centerX, y: self.bounds.height - height)
        }
    }
    
    // MARK: - Make Something
    
    func makeIndicator() -> UIView? {
        guard let indicatorColor = configuration.indicatorColor else {
            return nil
        }
        
        let result = UIView(frame: .zero)
        result.backgroundColor = indicatorColor
        
        return result
    }
}
