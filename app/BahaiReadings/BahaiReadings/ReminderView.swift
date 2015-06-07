//
//  ReminderView.swift
//  BahaiReadings
//
//  Created by James Tan on 6/1/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class ReminderView: UIViewController, UIAlertViewDelegate {

  
  @IBOutlet weak var reminderSegment: UISegmentedControl!
  @IBOutlet weak var reminderDescription: UILabel!
  @IBOutlet weak var readCount0: UILabel!
  @IBOutlet weak var readCount1: UILabel!
  @IBOutlet weak var readCount2: UILabel!
  @IBOutlet weak var resetCounter: UIButton!
  
  let sched0 : String = "You will not recieve any reminder to read."
  let sched1 : String = "You will recieve 1 reminder per week."
  let sched2 : String = "You will recieve 2 reminders per week."
  let sched4 : String = "You will recieve 4 reminders per week."
  let sched7 : String = "You will recieve a reminder every day."
  
  let resetTitle : String = "Confirm Reset"
  let resetBody : String = "Are you sure? This action cannot be undone."
  
  var scheduleDetails : NSArray = []
  
  class var shared : ReminderView {
    struct Static {
      static let instance : ReminderView = ReminderView()
    }
    return Static.instance
  }
  
  override func viewDidLoad() {
    scheduleDetails = [sched0, sched1, sched2, sched4, sched7]
    
    super.viewDidLoad()

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  @IBAction func resetReadCounter(sender: UIButton) {
    UIAlertView(title: resetTitle, message: resetBody, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Reset").show()
  }
  
  @IBAction func reminderSegmentChanged(sender: UISegmentedControl) {
    var index = sender.selectedSegmentIndex
    println(index)
    UIView.animateWithDuration(0.3, animations: {
      self.reminderDescription.alpha = 0.0
      }, completion: {
        finished in
        self.reminderDescription.text = (self.scheduleDetails.objectAtIndex(index) as! String)
        UIView.animateWithDuration(0.3, animations: {
          self.reminderDescription.alpha = 1.0
        })

    })
  }
  
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    println(buttonIndex)
    // 1 - Confirm
    if buttonIndex == 1 {
      //do something here to reset
    }
  }

}
