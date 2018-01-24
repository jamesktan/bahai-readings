//
//  SearchView.swift
//  readings2
//
//  Created by James Tan on 1/20/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit

class SearchView: UITableViewController, UISearchBarDelegate {
  
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  @IBOutlet weak var searchBar: UISearchBar!
  var paths : [String] = []
  var searchQueue : DispatchQueue = DispatchQueue(label: "SearchQueue")
  var fileParts : [(book:String,author:String,filename:String,counts:Int, path:String,results:[String])] = []
  var selectedFilePart : (book:String,author:String,filename:String,counts:Int,path:String,results:[String])? = nil

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
    searchBar.text = ""
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
    selectedFilePart = fileParts[indexPath.row]
    self.performSegue(withIdentifier: "showResults", sender: self)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SearchCell")
    let part = fileParts[indexPath.row]
    cell.textLabel?.text = "\(part.book)"
    cell.detailTextLabel?.text = "Author: \(part.author) --- Occurences: \(part.counts)"
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showResults" {
      
      if let destination = segue.destination as? SearchResultsView {
        destination.selectedFilePart = self.selectedFilePart
        destination.searchText = searchBar.text!
      }
      
    }
  }
  
  // Hardcore Search Heavy Lifting Stuff...
  
  func launchSearchTask(searchText:String) {
    self.fileParts = []
    indicator.startAnimating()
    searchQueue.async {
      
      for path in self.paths {
        print(path)
        if let contents = try? String(contentsOfFile: path) {
          let arrayContents = contents.components(separatedBy: "\n")
          var occuranceCount = 0
          var results : [String] = []
          for item in arrayContents {
            if item.lowercased().range(of:searchText.lowercased()) != nil {
              // String Exists!
              // Count the Occurance
              occuranceCount += 1
              results.append(item)
            }
          }
          
          // Map the Occuranges
          if occuranceCount > 0 {
            print("Count:\(occuranceCount)")
            let parts = path.fileNameComponent
            let newTuple : (String, String, String, Int, String, [String]) = (parts.book, parts.author, parts.filename, occuranceCount, path, results)
            self.fileParts.append(newTuple)
          }
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

