//
//  NoteView.swift
//  readings2
//
//  Created by James Tan on 1/25/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit

class NoteView : UITableViewController {
  
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var wiritngLabel: UILabel!
  @IBOutlet weak var creationDateLabel: UILabel!
  
  @IBOutlet weak var noteTextView: UITextView!
  
  @IBOutlet weak var commentTextView: UITextView!
  
  @IBOutlet weak var editSaveButton: UIButton!
  
  var note : Note!
  
  @IBAction func shareAction(_ sender: Any) {
    let shareText = "Text: \"\(noteTextView.text ?? "")\"\n\nComment: \(commentTextView.text  ?? "")\n\nWriting: \(wiritngLabel.text!)\n\nAuthor:\(authorLabel.text!)"
    let activity = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
    self.present(activity, animated: true, completion: nil)
  }
  
  @IBAction func goToWriting(_ sender: Any) {
    let fileName = "\(note.writing).md"
    let allPaths = Bundle.main.paths(forResourcesOfType: "md", inDirectory: nil)
    
    for path in allPaths {
      if NSString(string:path).contains(fileName) {
        launchReader(presentingView: self, path: path, page: note.page+1, passage: note.text)
        return
      }
    }
  }

  @IBAction func deleteAction(_ sender: Any) {
    let alert = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note? You will not be able to undo this action.", preferredStyle: .alert)
    let action = UIAlertAction(title: "DELETE", style: .destructive) { (act) in
      RealmAdapter.deleteNote(text: self.note.text)
      self.navigationController?.popViewController(animated: true)
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (act) in
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(cancel)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func editSaveAction(_ sender: Any) {
    let button = sender as! UIButton
    
    if commentTextView.isEditable {
      commentTextView.isEditable = false
      commentTextView.resignFirstResponder()
      button.setTitle("Edit", for: .normal)
      
      // Save the Edits
      RealmAdapter.updateNote(note: self.note, newComment: commentTextView.text)
      
    } else {
      commentTextView.isEditable = true
      commentTextView.becomeFirstResponder()
      button.setTitle("Save", for: .normal)
      
    }
  }
  
  var tapGesture : UITapGestureRecognizer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    noteTextView.isEditable = false
    noteTextView.text = note.text
    commentTextView.isEditable = false
    commentTextView.text = note.note
    
    let text = note.writing.components(separatedBy: " - ")
    authorLabel.text = text[1]
    wiritngLabel.text = text[0]
    creationDateLabel.text = "\(note.creationDate.readableString)"
    
    // Add a Tap GEsture
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
    tapGesture.numberOfTapsRequired = 1
    self.view.addGestureRecognizer(tapGesture)
    
  }
  
  @objc func didTap() {
    commentTextView.isEditable = false
    commentTextView.resignFirstResponder()
    editSaveButton.setTitle("Edit", for: .normal)
    RealmAdapter.updateNote(note: self.note, newComment: commentTextView.text)
  }
  
}

