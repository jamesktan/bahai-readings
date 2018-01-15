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
      let note = Note()

      try! realm.write {
        realm.add(note)
      }

    }
  }
}
