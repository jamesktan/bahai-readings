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
  @IBOutlet weak var writingTableView : UITableView!
  var sortOption : OrganizeWritingsState = OrganizeWritingsState.Author

  var paths : [Any] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    writingTableView.delegate = self
    writingTableView.dataSource = self
    
    // Paths
    paths = getPath(state: sortOption)
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cell = tableView.cellForRow(at: indexPath) as! WritingCell
    if let path = cell.path {
      wasLaunchFromMain = true
      launchReader(presentingView: self, path: path)
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if sortOption == .Author {
      return paths.count
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if sortOption == .Author {
      let author = (paths[section] as! [String]).first!.fileNameComponent.author
      return author
    }
    return sortOption.rawValue
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if sortOption == .Author {
      return (paths[section] as! [String]).count
    }
    return paths.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70.5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if sortOption == .Author {
      let cell = tableView.dequeueReusableCell(withIdentifier: "WritingCell") as! WritingCell
      cell.load(path: (paths[indexPath.section] as! [String])[indexPath.row])
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "WritingCell") as! WritingCell
    cell.load(path: paths[indexPath.row] as! String)
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
  {
    if sortOption == .Bookmarked || sortOption == .Starred {
      let modifyAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
        // Delete A Progress Indicator
        let cell = tableView.cellForRow(at: indexPath) as! WritingCell
        let name = cell.path.fileNameComponent.filename
        if self.sortOption == .Bookmarked {
          removeWritingProgress(filename: name)
        } else {
          _ = removeStarredWriting(fileName: name)
        }
        self.paths = getPath(state: self.sortOption)
        self.writingTableView.reloadData()
        success(true)
      })
      return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    return UISwipeActionsConfiguration(actions: [])
  }
  
  @IBAction func showSortOptions(_ sender: UIBarButtonItem) {
    let alert = UIAlertController.createWritingsSelection(completion: { state in
      self.sortOption = state
      if state != .None {
        self.paths = getPath(state: state)
        self.writingTableView.reloadData()
      }
    })
    self.present(alert, animated: true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
