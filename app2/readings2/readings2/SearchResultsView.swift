//
//  SearchResultsView.swift
//  readings2
//
//  Created by James Tan on 1/23/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit

class SearchResultCell : UITableViewCell {
  @IBOutlet weak var textView: UITextView!
  
  func load(searchText:String, path:String, text:String) {
    self.textView.text = text
  }
}

class SearchResultsView : UITableViewController {
  var selectedFilePart : (book:String,author:String,filename:String,counts:Int,path:String,results:[String])!
  var searchText : String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedFilePart.results.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
    cell.load(searchText: searchText, path: selectedFilePart.path, text: selectedFilePart.results[indexPath.row])
    return cell
  }
}
