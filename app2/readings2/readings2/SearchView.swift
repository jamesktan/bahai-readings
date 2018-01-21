//
//  SearchView.swift
//  readings2
//
//  Created by James Tan on 1/20/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit
class SearchCell : UITableViewCell {
  
}

class SearchView: UITableViewController, UISearchBarDelegate {
  
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  @IBOutlet weak var searchBar: UISearchBar!
  var paths : [String] = []
  var searchQueue : DispatchQueue = DispatchQueue(label: "SearchQueue")
  var fileParts : [(book:String,author:String,filename:String,counts:Int, path:String)] = []
  

  override func viewDidLoad() {
    super.viewDidLoad()
    paths = getPath(state: .All) as! [String]
    searchBar.delegate = self
  }
  
  // MARK: SearchBar Delegate

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText != "" {
      launchSearchTask(searchText: searchText)
    } else {
      fileParts = []
      self.tableView.reloadData()
    }
    searchBar.showsCancelButton = true
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    if let searchText = searchBar.text, searchText != "" {
      launchSearchTask(searchText: searchText)
    }
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = false

  }

  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = false
    fileParts = []
    self.tableView.reloadData()
  }
  
  // MARK: TableViewDelegate and DataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fileParts.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let path = fileParts[indexPath.row].path
    launchReader(presentingView: self, path: path)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SearchCell")
    let part = fileParts[indexPath.row]
    cell.textLabel?.text = "\(part.book)"
    cell.detailTextLabel?.text = "Author: \(part.author) --- Occurences: \(part.counts)"
    return cell
  }
  
  
  func launchSearchTask(searchText:String) {
    indicator.startAnimating()
    
    searchQueue.async {
      for path in self.paths {
        if let contents = try? String(contentsOfFile: path) {
          
          // Find Occurences
          let count = contents.countInstances(of: searchText)
          let name = path.fileNameComponent.book
          
          // Append to the right container
          if count > 0 {
            let parts = path.fileNameComponent
            let newTuple : (String, String, String, Int, String) = (parts.book, parts.author, parts.filename, count, path)
            self.fileParts.append(newTuple)
          }
          print("name: \(name) count: \(count)")
        }
      }
      
      DispatchQueue.main.async {
        
        // Sort the Counts
        self.fileParts = self.fileParts.sorted(by: { $0.counts > $1.counts })

        self.tableView.reloadData()
        self.indicator.stopAnimating()
      }
    }

  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

