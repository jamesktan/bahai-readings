//
//  Extensions.swift
//  readings2
//
//  Created by James Tan on 1/20/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit
import Down

var wasLaunchFromMain : Bool = false

let fontSize1 = """
h1   {
text-align: center;
padding-top: 0.5em;
font-size: 4em;
padding-bottom: 0.5em;
}
h2   {
text-align: center;
padding-top: 0.5em;
font-size: 3em;
padding-bottom: 0.5em;
}
h3   {
text-align: center;
padding-top: 0.5em;
font-size: 2em;
padding-bottom: 0.5em;
}
h4   {
text-align: center;
padding-top: 0.5em;
font-size: 2em;
padding-bottom: 0.5em;
}
p    {
font-size: 1.5em;
padding-bottom: 1.5em;
}
"""

let fontSize2 = """
h1   {
text-align: center;
padding-top: 0.5em;
font-size: 5em;
padding-bottom: 0.5em;
}
h2   {
text-align: center;
padding-top: 0.5em;
font-size: 4em;
padding-bottom: 0.5em;
}
h3   {
text-align: center;
padding-top: 0.5em;
font-size: 3em;
padding-bottom: 0.5em;
}
h4   {
text-align: center;
padding-top: 0.5em;
font-size: 3em;
padding-bottom: 0.5em;
}
p    {
font-size: 2em;
padding-bottom: 1.5em;
}
"""

let fontSize3 = """
h1   {
text-align: center;
padding-top: 0.5em;
font-size: 6em;
padding-bottom: 0.5em;
}
h2   {
text-align: center;
padding-top: 0.5em;
font-size: 5em;
padding-bottom: 0.5em;
}
h3   {
text-align: center;
padding-top: 0.5em;
font-size: 4em;
padding-bottom: 0.5em;
}
h4   {
text-align: center;
padding-top: 0.5em;
font-size: 4em;
padding-bottom: 0.5em;
}
p    {
font-size: 3em;
padding-bottom: 1.5em;
}
"""

let fontSize4 = """
h1   {
text-align: center;
padding-top: 0.5em;
font-size: 7em;
padding-bottom: 0.5em;
}
h2   {
text-align: center;
padding-top: 0.5em;
font-size: 6em;
padding-bottom: 0.5em;
}
h3   {
text-align: center;
padding-top: 0.5em;
font-size: 5em;
padding-bottom: 0.5em;
}
h4   {
text-align: center;
padding-top: 0.5em;
font-size: 5em;
padding-bottom: 0.5em;
}
p    {
font-size: 4em;
padding-bottom: 1.5em;
}
"""

let fontSize5 = """
h1   {
text-align: center;
padding-top: 0.5em;
font-size: 8em;
padding-bottom: 0.5em;
}
h2   {
text-align: center;
padding-top: 0.5em;
font-size: 7em;
padding-bottom: 0.5em;
}
h3   {
text-align: center;
padding-top: 0.5em;
font-size: 6em;
padding-bottom: 0.5em;
}
h4   {
text-align: center;
padding-top: 0.5em;
font-size: 6em;
padding-bottom: 0.5em;
}
p    {
font-size: 5em;
padding-bottom: 1.5em;
}
"""


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
  case Bookmarked = "Writings with Bookmarks"
  case Author = "Grouped by Author"
  case None = "None"
  case Recent = "Recently Opened"
}

// Global Functions

// Reader Settings
func saveReaderTheme(theme:Int) {
  UserDefaults.standard.set(theme, forKey: Constants.ThemeKey)
}
func getReaderTheme() -> Int {
  if let value = UserDefaults.standard.value(forKey: Constants.ThemeKey) as? Int {
    return value
  }
  return 0
}
func saveReaderFontSize(size:Float) {
  UserDefaults.standard.set(size, forKey: Constants.FontSizeKey)
}
func getReaderFontSize() -> Float {
  if let value = UserDefaults.standard.value(forKey: Constants.FontSizeKey) as? Float {
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
func removeWritingProgress(filename:String) {
  if let progress = UserDefaults.standard.dictionary(forKey: Constants.ProgressKey) as? [String:[Any]] {
    if progress.keys.contains(filename) {
      var newProgress = progress
      newProgress.removeValue(forKey: filename)
      UserDefaults.standard.set(newProgress, forKey: Constants.ProgressKey)
    }
  }}

func getPath(state:OrganizeWritingsState) -> [Any] {
  
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
  if state == .Bookmarked {
    let allPaths = Bundle.main.paths(forResourcesOfType: "md", inDirectory: nil)
    let bookmarks = getWritingProgressKeys() // Reall Filenames
    
    var bookmarkedPaths : [String] = []
    for path in allPaths {
      if bookmarks.contains(path.fileNameComponent.filename) {
        bookmarkedPaths.append(path)
      }
    }
    return bookmarkedPaths
  }
  if state == .Author {
    let allPaths = Bundle.main.paths(forResourcesOfType: "md", inDirectory: nil)
    var authors : [String] = []
    var pathDictionary : [String:[String]] = [:]
    for path in allPaths {
      let result = path.fileNameComponent
      let author = result.author
      if !authors.contains(author) { // Doesn't exist? Add to the list and Add to the dictionary Mapping
        authors.append(author)
        pathDictionary[author] = [path]
      } else { // Exists? Add to the dictionary mapping.
        var authorPaths = pathDictionary[author]!
        authorPaths.append(path)
        pathDictionary[author] = authorPaths
      }
    }
    // Order the Authors
    authors = [
      "The Báb",
      "Bahá’u’lláh",
      "‘Abdu’l-Bahá",
      "Shoghi Effendi",
      "Universal House of Justice",
      "Baha\'i World Centre",
      "Research Department of the Universal House of Justice",
      "Baha\'i International Community",
      " ‘Abdu’l-Bahá, `Ali Muhammad Shirazi Bab, and Bahá\'u\'lláh"
    ]
    // Pull out the Array from Dictionary
    var finalStructure : [[String]] = []
    for author in authors {
      let array = pathDictionary[author]!
      finalStructure.append(array)
    }
    return finalStructure
  }
  
  return []
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
  var index : Int = 0
  for page in pages {
    
    
    var rendered = template.replacingOccurrences(of: "{{content}}", with: page.contentsConverted!)
    
    
    // Apply the Font Size Calculation
    let size = getReaderFontSize()
    if size < 0.2 { // Make Smaller
      rendered = rendered.replacingOccurrences(of: "{{fontSizes}}", with: fontSize1)
    } else if size > 0.2 && size < 0.4 {
      rendered = rendered.replacingOccurrences(of: "{{fontSizes}}", with: fontSize2)
    } else if size > 0.4 && size < 0.6 {
      rendered = rendered.replacingOccurrences(of: "{{fontSizes}}", with: fontSize3) // Normal
    } else if size > 0.6 && size < 0.8 {
      rendered = rendered.replacingOccurrences(of: "{{fontSizes}}", with: fontSize4)
    } else {
      rendered = rendered.replacingOccurrences(of: "{{fontSizes}}", with: fontSize5)
    }
    
    let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageView") as! PageView
    view.contents = rendered
    view.tableOfContents = table
    view.index = index
    view.title = table.title
    
    viewControllers.append(view)
    
    index += 1

  }
  return viewControllers
}

func launchReader(presentingView:UIViewController, path:String, page:Int?=nil, passage:String?=nil) {
  
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
    
    let pController = PageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    pController.setup()
    pController.storedViewController = viewControllers
    var currentViewController : UIViewController? = nil
    
    if page != nil && passage != nil { // If a page is given and a passage exists
      currentViewController = viewControllers[page!-1]
      (currentViewController as? PageView)?.passage = passage
    } else if let page = getWritingProgress(fileName: result.0!.fileName)?.page {
      currentViewController = (page > 0) ? viewControllers[page] : viewControllers[0]
    } else {
      currentViewController = viewControllers[0]
    }

    pController.setViewControllers([currentViewController!], direction: .forward, animated: true, completion: nil)
    pController.title = currentViewController?.title
    navigation = UINavigationController(rootViewController: pController)
    presentingView.present(navigation!, animated: true, completion: nil)

  }
}
var navigation : UINavigationController? = nil

extension Date {
  var readableString : String {
    get {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM/dd/yy - H:m:s"
      return formatter.string(from: self)
    }
  }
}

extension String {
  var fileNameComponent : (book:String, author:String, filename: String) {
    get {
      let name = NSString(string:self)
      let file = name.lastPathComponent
      let parts = file.components(separatedBy: ".") // Trim the extension
      let components = parts.first!.components(separatedBy: " - ") // Get Book / Author
      return (book:components.first!, author:components.last!, filename: file)
    }
  }
  
  func countInstances(of stringToFind: String) -> Int {
    assert(!stringToFind.isEmpty)
    var stringToSearch = self
    var count = 0
    while let foundRange = stringToSearch.range(of: stringToFind, options: .diacriticInsensitive) {
      stringToSearch = stringToSearch.replacingCharacters(in: foundRange, with: "")
      count += 1
    }
    return count
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
//    let starred = UIAlertAction(title: OrganizeWritingsState.Starred.rawValue, style: .default, handler: { action in
//      completion(OrganizeWritingsState.Starred)
//    })
    let bookmarked = UIAlertAction(title: OrganizeWritingsState.Bookmarked.rawValue, style: .default, handler: { action in
      completion(OrganizeWritingsState.Bookmarked)
    })
    let author = UIAlertAction(title: OrganizeWritingsState.Author.rawValue, style: .default, handler: { action in
      completion(OrganizeWritingsState.Author)
    })
    
    alert.addAction(all)
//    alert.addAction(starred)
    alert.addAction(bookmarked)
    alert.addAction(author)
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

