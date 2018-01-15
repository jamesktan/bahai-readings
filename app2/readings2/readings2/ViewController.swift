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

struct Constants {
  static var StarredKey : String = "StarredWritingsKey"
  static var ProgressKey : String = "ProgressDictionaryKey"
  static var ThemeKey : String = "ReaderThemeKey"
  static var FontSizeKey : String = "ReaderFontSizeKey"
}
struct TableOfContents {
  var fileName : String = ""
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
  case Author = "Grouped by Author"
  case None = "None"
  case Recent = "Recently Opened"
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
    let alert = UIAlertController.createWritingsSelection(completion: { state in
      
    })
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
      
      Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
        if let page = getWritingProgress(fileName: result.0!.fileName)?.page {
          self.pageController.goTo(page)
        }
      })
      
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

// Reader Settings
func saveReaderTheme(theme:Int) {
  UserDefaults.standard.set(theme, forKey: Constants.ThemeKey)
}
func getReaderTheme() -> Int {
  if let value = UserDefaults.standard.integer(forKey: Constants.ThemeKey) as Int {
    return value
  }
  return 0
}
func saveReaderFontSize(size:Float) {
  UserDefaults.standard.set(size, forKey: Constants.FontSizeKey)
}
func getReaderFontSize() -> Float {
  if let value = UserDefaults.standard.float(forKey: Constants.FontSizeKey) as Float {
    return value
  }
  return 0.5
}

// Starred Writings with User Defaults
func saveStarredWriting(fileName:String) {
  if let starred = UserDefaults.standard.array(forKey: Constants.StarredKey) as? [String] {
    var new = starred
    new.append(fileName)
    UserDefaults.standard.set(new, forKey: Constants.StarredKey)
  } else {
    let new = [fileName]
    UserDefaults.standard.set(new, forKey: Constants.StarredKey)
  }
}

func getStarredWritings() -> [String] {
  if let starred = UserDefaults.standard.array(forKey: Constants.StarredKey) as? [String] {
    return starred
  }
  return []
}

func removeStarredWriting(fileName:String) -> Bool? {
  if let starred = UserDefaults.standard.array(forKey: Constants.StarredKey) as? [String] {
    let new : NSMutableArray = NSMutableArray(array:starred)
    if !new.contains(fileName) {
      return false
    }
    new.remove(fileName)
    let save = new as! [String]
    UserDefaults.standard.set(save, forKey: Constants.StarredKey)
    return true
  } else {
    return nil
  }
}

// Progress Writings with User Defaults

func storeWritingProgress(fileName:String, page:Int, position:Float) {
  if let progress = UserDefaults.standard.dictionary(forKey: Constants.ProgressKey) as? [String:[Any]] {
    var copy = progress
    copy[fileName] = [page, position]
    UserDefaults.standard.set(copy, forKey: Constants.ProgressKey)
  } else {
    let new : NSDictionary = NSDictionary(dictionary:[fileName:[page, position]])
    UserDefaults.standard.set(new, forKey: Constants.ProgressKey)
  }
}
func getWritingProgressKeys() -> [String] {
  if let progress = UserDefaults.standard.dictionary(forKey: Constants.ProgressKey) as? [String:[Any]] {
    return Array(progress.keys) as [String]
  } else {
    return []
  }
}

func getWritingProgress(fileName:String) -> (page:Int, position:Float)? {
  if let progress = UserDefaults.standard.dictionary(forKey: Constants.ProgressKey) as? [String:[Any]] {
    if progress.keys.contains(fileName) {
      let data = progress[fileName]!
      return (data[0], data[1]) as! (Int, Float)
    } else {
      return nil
    }
  } else {
    return nil
  }
}


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
          tableOfContents = TableOfContents(fileName: result.2, title:result.0, author:result.1, contents:cachedTableOfContents)
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
  var fileNameComponent : (String, String, String) {
    get {
      let name = NSString(string:self)
      let file = name.lastPathComponent
      let parts = file.components(separatedBy: ".") // Trim the extension
      let components = parts.first!.components(separatedBy: " - ") // Get Book / Author
      return (components.first!, components.last!, file)
    }
  }
}

extension UIAlertController {
  static func createWritingsSelection(completion:@escaping (_ selected:OrganizeWritingsState)->()) -> UIAlertController {
    
    let alert = UIAlertController(title: "Organize Writings", message: "Select a method to sort writings.", preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
      completion(.None)
    })
    let all = UIAlertAction(title: OrganizeWritingsState.All.rawValue, style: .default, handler: { action in
      completion(OrganizeWritingsState.All)
    })
    let starred = UIAlertAction(title: OrganizeWritingsState.Starred.rawValue, style: .default, handler: { action in
      completion(OrganizeWritingsState.Starred)
    })
//    let author = UIAlertAction(title: OrganizeWritingsState.Author.rawValue, style: .default, handler: { action in
//      completion(OrganizeWritingsState.Author)
//    })
//    let recent = UIAlertAction(title: OrganizeWritingsState.Recent.rawValue, style: .default, handler: { action in
//      completion(OrganizeWritingsState.Recent)
//    })
    alert.addAction(all)
    alert.addAction(starred)
//    alert.addAction(author)
//    alert.addAction(recent)
    alert.addAction(cancel)
    return alert
  }
}

extension UIView {
  func setAlpha(alpha:CGFloat, duration:TimeInterval=0.3, completion:(()->())?=nil) {
    UIView.animate(withDuration: duration, animations: {
      self.alpha = alpha
    }, completion: { finished in
      completion?()
    })
  }
}


