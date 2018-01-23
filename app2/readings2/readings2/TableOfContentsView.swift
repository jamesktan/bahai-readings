//
//  TableOfContentsView.swift
//  readings2
//
//  Created by James Tan on 1/23/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit

class TableOfContentsView : UITableViewController {
  
  var tableOfContents : TableOfContents!
  
  // MARK: TableViewDelegate Methods
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 2
    } else {
      return tableOfContents.contents.count
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Writing Information"
    } else {
      return "Table of Contents"
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        cell.textLabel?.text = "Title: \(tableOfContents.title)"
      } else {
        cell.textLabel?.text = "Author: \(tableOfContents.author)"
      }
    } else {
      cell.textLabel?.text = tableOfContents.contents[indexPath.row]
    }
    return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.section == 1 {
      if let root = self.navigationController?.viewControllers[0] as? PageController {
        root.goTo(indexPath.row)
      }
      self.navigationController?.popViewController(animated: true)
    }
  }
  
}

