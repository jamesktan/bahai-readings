//
//  PageController.swift
//  readings2
//
//  Created by James Tan on 1/22/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit

class PageController : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  var storedViewController : [UIViewController] = []
  
  func setup() {
    self.dataSource = self
    self.delegate = self
  }
  
  var currentIndex : Int {
    get {
      if currentPageIndex == nil {
        return (self.viewControllers?.first! as! PageView).index
      }
      return currentPageIndex!
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
  }
  
  var isFirst : Bool = true
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    super.viewWillDisappear(animated)
  }
  
  func goTo(_ page:Int, isForward:Bool=true) {
    
    // Check the Page
    if page >= self.storedViewController.count || page < 0 {
      return
    }
    
    // Current Page
    currentPageIndex = page
    
    // Ftch the VC
    let vc = self.storedViewController[page]
    
    // Set the Direction
    var direction : UIPageViewControllerNavigationDirection!
    if isForward {
      direction = .forward
    } else {
      direction = .reverse
    }
    
    // Not sure why the below works but it does
    weak var weakPageVc = vc
    self.setViewControllers([vc], direction: direction, animated: true) { finished in
      guard weakPageVc != nil else {
        return
      }
      DispatchQueue.main.async {
        self.setViewControllers([vc], direction: direction, animated: false)
      }
    }

  }
  
  func showTableOfContents(_ content:TableOfContents) {
    if let table = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TableOfContents") as? TableOfContentsView {
      table.tableOfContents = content
      self.navigationController!.pushViewController(table, animated: true )
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let index = self.storedViewController.index(of: viewController)
    let newIndex = index!.advanced(by: 1)
    if newIndex < self.storedViewController.count {
      let vc = self.storedViewController[newIndex]
      return vc
    }
    return nil
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let index = self.storedViewController.index(of: viewController)
    let newIndex = index!.advanced(by: -1)
    if newIndex >= 0 {
      let vc = self.storedViewController[newIndex]
      return vc
    }
    return nil
  }
  
  var lastPendingViewControllerIndex : Int = 0
  var currentPageIndex : Int? = nil
  
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
    // 1
    if let viewController = pendingViewControllers[0] as? PageView {
      // 2
      self.lastPendingViewControllerIndex = viewController.index
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    // 1
    if completed {
      // 2
      self.currentPageIndex = self.lastPendingViewControllerIndex
    }
  }

}

