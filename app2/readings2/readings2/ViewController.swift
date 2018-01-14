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
  var title : String = ""
  var author : String = ""
  var contents : [String] = []
  var combined : String {
    get {
      return "\(title) - \(author)"
    }
  }
}

enum OrganizeWritingsState : String {
  case All = "All Writings"
  case Starred = "Starred Writings"
  case Author = "Author"
}


class WritingCell : UITableViewCell {
  @IBOutlet weak var writingTitle: UILabel!
  @IBOutlet weak var writingAuthor: UILabel!
  @IBOutlet weak var writingComplete: UILabel!
  var path : String!
  
  func load(path:String) {
    self.path = path
    let filename = NSString(string: path).lastPathComponent.replacingOccurrences(of: ".md", with: "")
    self.writingComplete.alpha = 0.0
    
    let components = String(filename).components(separatedBy: " - ")
    self.writingTitle.text = components[0]
    self.writingAuthor.text = components[1]
  }
}

class WritingsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var navigation : UINavigationController!
  var pageController : PagesController!
  @IBOutlet weak var writingTableView : UITableView!

  var paths : [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    writingTableView.delegate = self
    writingTableView.dataSource = self
    
    // Paths
    guard let path = Bundle.main.path(forResource: "God Passes By - Shoghi Effendi", ofType: "md") else {
      return
    }
    paths.append(path)
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cell = tableView.cellForRow(at: indexPath) as! WritingCell
    let path = cell.path
    launchReader(path: path!)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return paths.count
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70.5
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WritingCell") as! WritingCell
    cell.load(path: paths[indexPath.row])
    return cell
  }
  
  @IBAction func showSortOptions(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Sort Options", message: "Select a sorting option", preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
      alert.dismiss(animated: true, completion: nil)
    })
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  
  func launchReader(path:String) {
    guard let templatePath = Bundle.main.path(forResource: "ReaderTemplate", ofType: "html") else {
      return
    }
    
    if let template = try? String(contentsOfFile:templatePath)
    {
      let result : (TableOfContents?, [Page]?) = createPages(pathToResource: path)
      let viewControllers = createViewsForPages(table: result.0!, pages: result.1!, template:template)
      pageController = PagesControllerHidden(viewControllers)
      
      pageController.enableSwipe = true
      pageController.showBottomLine = true
      pageController.showPageControl = false
      
      navigation = UINavigationController(rootViewController: pageController)
      navigation.navigationBar.isHidden = true
    }
    self.present(navigation, animated: true, completion: nil)

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// Override to Hide Toolbar

class PagesControllerHidden : PagesController {
  override var prefersStatusBarHidden: Bool {
    return true
  }
}


// Global Functions

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
        cachedTableOfContents.append(row.replacingOccurrences(of: "*", with: ""))
      }
        
      // On HR, If first then create a Table of Contents
      // On HR, if NOT, create a new Page
      else if row.contains("---") {
        if tableOfContents == nil {
          let result = pathToResource.fileNameComponent
          tableOfContents = TableOfContents(title:result.0, author:result.1, contents:cachedTableOfContents)
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

func createViewsForPages(table: TableOfContents, pages:[Page], template:String) -> [UIViewController] {
  var viewControllers : [UIViewController] = []
  for page in pages {
    let rendered = template.replacingOccurrences(of: "{{content}}", with: page.contentsConverted!)
    
    let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageView") as! PageView
    view.contents = rendered
    view.tableOfContents = table
    
    viewControllers.append(view)
  }
  return viewControllers
}

extension String {
  var fileNameComponent : (String, String) {
    get {
      let name = NSString(string:self)
      let file = name.lastPathComponent
      let parts = file.components(separatedBy: ".") // Trim the extension
      let components = parts.first!.components(separatedBy: " - ") // Get Book / Author
      return (components.first!, components.last!)
    }
  }
}

