//
//  PageController.swift
//  readings2
//
//  Created by James Tan on 1/22/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit

class PageController : UIPageViewController, UIPageViewControllerDataSource {
  var storedViewController : [UIViewController] = []
  
  func setup() {
    self.dataSource = self
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let index = self.storedViewController.index(of: viewController)
    let newIndex = index!.advanced(by: 1)
    if newIndex < self.storedViewController.count {
      return self.storedViewController[newIndex]
    }
    return nil
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let index = self.storedViewController.index(of: viewController)
    let newIndex = index!.advanced(by: -1)
    if newIndex >= 0 {
      return self.storedViewController[newIndex]
    }
    return nil
  }
}

