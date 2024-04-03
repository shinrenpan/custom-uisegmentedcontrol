Title: 客製化 UISegmentedControl 實現分頁  
Cateogries: [iOS][L1]  
Labels: [UISegmentedControl][L2], [UIPageViewController][L3]  

## 前言  
iOS App 實作分頁功能, 基本上都是用 UISegmentedControl,  
但是大部分的美術都不喜歡這個內建元件.  

本篇用最簡單的方式 UISegmentedControl + UIPageViewController 實作分頁功能,  
點擊 UISegmentedControl 自動切換 UIPageViewController,  
手滑 UIPageViewController 自動切換 UISegmentedControl.

<img src="/images/screenshot.gif" width="300" height="auto">

## 實作  
繼承一個 UISegmentedControl, 並在 layoutSubviews 設置  layer,  
這樣一來繼承的 UISegmentedControl 就不會長得原生的一樣,  
例如實作僅左上右上圓角:  

```swift
override func layoutSubviews() {
     super.layoutSubviews()
     layer.cornerRadius = 20
     layer.masksToBounds = true
     layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
}
```

接下來其他實作就像一般 UIView 相同了.

> [!WARNING]  
> 一定要在 layoutSubviews 實作, 不然點擊 UISegmentedControl 後又會恢復原生樣式.

最後透過 UIPageViewController.setViewControllers 與 UIPageViewControllerDataSource 及 UIPageViewControllerDelegate,  
來達到交互效果.

[L1]:  https://github.com/shinrenpan/Note/discussions/categories/ios
[L2]: https://github.com/shinrenpan/Note/discussions?discussions_q=label:UISegmentedControl
[L3]: https://github.com/shinrenpan/Note/discussions?discussions_q=label:UIPageViewController
