//
//  NotesView.swift
//  readings2
//
//  Created by James Tan on 1/14/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit

class NotesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var notesTable: UITableView!
  var notes : [Note] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    notesTable.delegate = self
    notesTable.dataSource = self
  }
 
  override func viewWillAppear(_ animated: Bool) {
    RealmAdapter.getNotes(completion: { (notes) in
      self.notes = notes
      self.notesTable.reloadData()
    })
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "NotesCell")
    cell.textLabel?.text = notes[indexPath.row].writing
    cell.detailTextLabel?.text = notes[indexPath.row].text
    return cell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func sortNotes(_ sender: Any) {
  }
  
}

