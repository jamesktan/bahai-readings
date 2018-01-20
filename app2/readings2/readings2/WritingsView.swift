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
    paths = getPath(state: OrganizeWritingsState.All)
  }
  
  func getPath(state:OrganizeWritingsState) -> [String] {
    
    if state == .All {
      let allPaths = Bundle.main.paths(forResourcesOfType: "md", inDirectory: nil)
      return allPaths
    }
    if state == .Starred {
      let allPaths = Bundle.main.paths(forResourcesOfType: "md", inDirectory: nil)
      let starred = getStarredWritings()

      // Parse the Paths
      var parsedPaths : [String] = []
      for path in allPaths {
        let results = path.fileNameComponent
        let filename = results.2
        if starred.contains(filename) {
          parsedPaths.append(path)
        }
      }
      return parsedPaths
    }
    return []
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
    let alert = UIAlertController.createWritingsSelection(completion: { state in
      if state != .None {
        self.paths = self.getPath(state: state)
        self.writingTableView.reloadData()
        self.title = state.rawValue
      }
    })
    self.present(alert, animated: true, completion: nil)
  }
  
  func launchReader(path:String) {
    let templateTheme = getReaderTheme()
    var name : String!
    if templateTheme == 0 { name = "ReaderTemplateLight" }
    if templateTheme == 1 { name = "ReaderTemplateDark" }
    if templateTheme == 2 { name = "ReaderTemplateSepia" }
    guard let templatePath = Bundle.main.path(forResource: name, ofType: "html") else {
      return
    }
    
    if let template = try? String(contentsOfFile:templatePath)
    {
      let result : (TableOfContents?, [Page]?) = createPages(pathToResource: path)
      let viewControllers = createViewsForPages(table: result.0!, pages: result.1!, template:template)
      pageController = PagesControllerHidden(viewControllers)
      
      Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
        if let page = getWritingProgress(fileName: result.0!.fileName)?.page {
          self.pageController.goTo(page)
        }
      })
      
      pageController.enableSwipe = true
      pageController.showBottomLine = false
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


