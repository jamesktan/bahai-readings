//
//  RealmAdapter.swift
//  readings2
//
//  Created by James Tan on 1/14/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit
import RealmSwift

class Note: Object {
  @objc dynamic var creationDate = Date()
  @objc dynamic var page = 0
  @objc dynamic var startIndex = 0
  @objc dynamic var text = ""
  @objc dynamic var writing = ""
  @objc dynamic var note = ""

}

let realm = try! Realm()

class RealmAdapter: NSObject {

  static func createNote(creationDate:Date, page:Int, startIndex:Int, text:String,  writing:String, note:String) {
    DispatchQueue.main.async {
      let noteObj = Note()
      noteObj.creationDate = creationDate
      noteObj.page = page
      noteObj.startIndex = startIndex
      noteObj.text = text
      noteObj.writing = writing
      noteObj.note = note

      try! realm.write {
        realm.add(noteObj)
      }
    }
  }
  
  static func updateNote(note:Note, newComment:String) {
    DispatchQueue.main.async {
      try! realm.write {
        note.note = newComment
      }
    }
  }
  static func deleteNote(text:String) {
    DispatchQueue.main.async {
      if let note = realm.objects(Note.self).filter("text == '\(text)'").first {
        try! realm.write {
          realm.delete(note)
        }
      }
    }
  }
  
  
  
  static func getNotes( completion:@escaping ((_ notes:[Note])->())) {
    DispatchQueue.main.async {
      let notes = realm.objects(Note.self).toArray(ofType: Note.self)
      completion(notes)
    }
  }
}

extension Results {
  
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for result in self {
      if let result = result as? T {
        array.append(result)
      }
    }
    return array
  }
}
