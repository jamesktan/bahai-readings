//
//  SearchView.swift
//  readings2
//
//  Created by James Tan on 1/20/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit

class SearchView: UITableViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  var paths : [Any] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    paths = getPath(state: .All)
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
}

