//
//  SearchView.swift
//  readings2
//
//  Created by James Tan on 1/20/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit

class SearchView: UITableViewController, UISearchBarDelegate {
  
  @IBOutlet weak var searchBar: UISearchBar!
  var paths : [String] = []
  var searchQueue : DispatchQueue = DispatchQueue(label: "SearchQueue")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    paths = getPath(state: .All) as! [String]
    searchBar.delegate = self
    
  }
  
  // MARK: SearchBar Delegate

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText != "" {
      launchSearchTask(searchText: searchText)
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    if let searchText = searchBar.text, searchText != "" {
      launchSearchTask(searchText: searchText)
    }
    
    
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

  }
  
  // MARK: TableViewDelegate and DataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "SearchCell")
    return cell
  }
  
  
  //
  
  func launchSearchTask(searchText:String) {
    var countMapping : [String:Int] = [:]
    var names : [String] = []
    var counts : [Int] = []

    searchQueue.async {
      for path in self.paths {
        if let contents = try? String(contentsOfFile: path) {
          
          // Find Occurences
          let count = contents.countInstances(of: searchText)
          let name = path.fileNameComponent.filename
          
          // Append to the right container
          if count > 0 {
            countMapping[name] = count
            counts.append(count)
            names.append(name)
          }
          print("name: \(name) count: \(count)")
        }
      }
    }

  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

