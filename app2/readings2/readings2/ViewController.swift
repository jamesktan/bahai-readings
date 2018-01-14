//
//  ViewController.swift
//  readings2
//
//  Created by James Tan on 12/21/17.
//  Copyright © 2017 James Tan. All rights reserved.
//

import UIKit
import WebKit
import Down
import Pages

struct Page {
  var contents : [String] = []
  var contentsConverted : String? {
    get {
      let joinedContents = contents.joined(separator: "\n")
      let down = Down(markdownString: joinedContents)
      guard let html = try? down.toHTML() else {
        return nil
      }
      return html
    }
  }
}

struct TableOfContents {
  var contents : [String] = []
}


class ViewController: UIViewController {
  
  var navigation : UINavigationController!
  var pageController : PagesController!

  func createPages(pathToResource:String) -> (TableOfContents?, [Page]?) {
    if let contents = try? String(contentsOfFile: pathToResource) {
      // Convert to Array
      let contentsArray = contents.components(separatedBy: .newlines)

      // Populate Table of Contents and Links
      var tableOfContents : TableOfContents? = nil
      var cachedTableOfContents : [String] = []
      var finished = false
      var index = 0
      var page : Page? = nil
      var pages : [Page] = [] // Create Pages At Horizontal Rules
      
      while !finished {
        let row = contentsArray[index]
        
        // Parse for the Table of Contents
        if row.contains("*") && tableOfContents == nil {
          cachedTableOfContents.append(row)
        }
          
          // On HR, If first then create a Table of Contents
          // On HR, if NOT, create a new Page
        else if row.contains("---") {
          if tableOfContents == nil {
            tableOfContents = TableOfContents(contents:cachedTableOfContents)
            page = Page()
          } else {
            if page != nil {
              pages.append(page!)
            }
            page = Page()
          }
        }
          
        // Add Content to the Page
        else {
          if page != nil {
            page!.contents.append(row)
          }
        }
        
        // Increment the Index
        index += 1
        
        // Wrap up and Save the Last Page
        if index == contentsArray.endIndex {
          finished = true
          if page != nil {
            pages.append(page!)
          }
          return (tableOfContents, pages)
        }
      }
    }
    return(nil,nil)
  }
  
  func createViewsForPages(pages:[Page], template:String) -> [UIViewController] {
    var viewControllers : [UIViewController] = []
    for page in pages {
      let rendered = template.replacingOccurrences(of: "{{content}}", with: page.contentsConverted!)
      
      let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageView") as! PageView
      view.contents = rendered
      viewControllers.append(view)
    }
    return viewControllers
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Paths
    guard let path = Bundle.main.path(forResource: "God Passes By - Shoghi Effendi", ofType: "md") else {
      return
    }
    guard let templatePath = Bundle.main.path(forResource: "ReaderTemplate", ofType: "html") else {
      return
    }
    
    // Start Templating
    if let template = try? String(contentsOfFile:templatePath)
    {
      let result : (TableOfContents?, [Page]?) = createPages(pathToResource: path)
      let viewControllers = createViewsForPages(pages: result.1!, template:template)
      pageController = PagesControllerHidden(viewControllers)

      pageController.enableSwipe = true
      pageController.showBottomLine = true
      pageController.showPageControl = false
      
      navigation = UINavigationController(rootViewController: pageController)
      navigation.navigationBar.isHidden = true
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.present(navigation, animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

class PagesControllerHidden : PagesController {
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  var items = [UIBarButtonItem]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.navigationController?.isToolbarHidden = false
//    items.append(
//      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//    )
//    items.append(
//      UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(closeReader))
//    )
////    self.navigationController?.toolbar.items = items
//    self.navigationController?.toolbar.setItems(items, animated: false)
//
//    var items : [UIBarButtonItem] = []
//    items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
//    let button2 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(closeReader))
//    items.append( button2 )
//    self.navigationController?.toolbarItems = items
//    self.navigationController?.setToolbarItems(items, animated: true  )

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  @objc func closeReader() {
    
  }
}

