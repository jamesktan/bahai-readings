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
  
  var currentIndex : Int {
    get {
      if let presented = self.presentedViewController {
        if let index = self.storedViewController.index(of: presented) {
          return index.advanced(by: 0)
        }
      }
      return 0
    }
  }
  
  func goTo(_ page:Int) {
    
  }
  
  func showTableOfContents(_ content:TableOfContents) {
    if let table = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TableOfContents") as? TableOfContentsView {
      table.tableOfContents = content
      self.navigationController?.pushViewController(table, animated: true )
      self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
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

