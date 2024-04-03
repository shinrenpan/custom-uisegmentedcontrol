//
//  MainTabSegment.swift
//
//  Created by Shinren Pan on 2024/4/3.
//
//

import UIKit

final class MainTabSegment: UISegmentedControl {
    
    let titles: [String]
    private var firstInit = true
    private var indecator: UIView
    
    init(titles: [String]) {
        self.titles = titles
        self.indecator = .init(frame: .zero)
        self.indecator.backgroundColor = .brown
        super.init(frame: .zero)
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 要設置 Layer 相關設定, 一定要在 layoutSubviews 設置
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        updateUI()
    }
}

// MARK: - Private

private extension MainTabSegment {
    // MARK: Setup Something
    
    func setupSelf() {
        for (idx, title) in titles.enumerated() {
            insertSegment(withTitle: title, at: idx, animated: false)
        }
        
        setTitleTextAttributes([
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor.brown
        ], for: .selected)
        
        setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ], for: .normal)
        
        selectedSegmentIndex = 0
        selectedSegmentTintColor = .clear
        
        backgroundColor = .yellow
        
        // 移除分隔線
        setBackgroundImage(UIColor.yellow.toImage(), for: .normal, barMetrics: .default)
        setDividerImage(UIColor.yellow.toImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        addSubview(indecator)
    }
    
    // MARK: - Update Something
    
    func updateUI() {
        let width = frame.width / CGFloat(numberOfSegments)
        let leading = CGFloat(selectedSegmentIndex) * width
        let duration = firstInit ? 0.0 : 0.2
        firstInit = false
        
        UIView.animate(withDuration: duration) {
            self.indecator.frame = .init(x: leading, y: self.bounds.height - 4, width: width, height: 4)
        }
    }
}

private extension UIColor {
    func toImage() -> UIImage {
        UIGraphicsImageRenderer(size: .init(width: 1, height: 1))
            .image { ctx in
                self.setFill()
                ctx.fill(.init(x: 0, y: 0, width: 1, height: 1))
            }
    }
}
