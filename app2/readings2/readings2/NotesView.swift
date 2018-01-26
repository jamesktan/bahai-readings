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
  
  var selectedNote : Note? = nil
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectedNote = notes[indexPath.row]
    self.performSegue(withIdentifier: "showNote", sender: self)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "NotesCell")
    cell.textLabel?.text = notes[indexPath.row].writing
    cell.detailTextLabel?.text = notes[indexPath.row].text
    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
  {
    let modifyAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
      // Delete A Note
      let note = self.notes[indexPath.row]
      RealmAdapter.deleteNote(text: note.text)
      RealmAdapter.getNotes(completion: { (notes) in
        self.notes = notes
        DispatchQueue.main.async {
          self.notesTable.reloadData()
        }
      })
      success(true)
    })
    return UISwipeActionsConfiguration(actions: [modifyAction])
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showNote" {
      if let destination = segue.destination as? NoteView {
        destination.note = selectedNote
      }
    }
  }
}
