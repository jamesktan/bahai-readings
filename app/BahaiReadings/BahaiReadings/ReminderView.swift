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
  @IBOutlet weak var resetCounter: UIButton!
  
  let sched0 : String = "You will not recieve any reminder to read."
  let sched1 : String = "You will be reminded every Monday."
  let sched2 : String = "You will be reminded every Monday and Wednesday."
  let sched4 : String = "You will be reminded every Monday, Wednesday, Friday, and Saturday"
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
    
    // Setup
    highlightSelectedSchedule(getSelectedSchedule())
  }
  
  
  override func viewWillAppear(animated: Bool) {
    UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |
      UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
    var vals = getCounterValues()
    setCounterValues(vals.0, val2: vals.1, val3: vals.2)

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
        
        // Business Logic
        self.clearAndSetReminderForSchedule(index)
        
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
      resetCounterValues()
      setCounterValues("0", val2: "0", val3: "0")
    }
  }

  func clearAndSetReminderForSchedule(index:Int) {
    
    UIApplication.sharedApplication().cancelAllLocalNotifications()
    var notifs : NSArray = []
    var fireDates : NSArray = []
    var state : String = "never"
    
    if index == 1 { // Monday
      fireDates = [getDateOfSpecificDay(2)]
      notifs = createLocalNotifications(1)
      state = "1week"
    }
    if index == 2 {
      var monday : NSDate = getDateOfSpecificDay(2)
      var wednesday : NSDate = getDateOfSpecificDay(4)
      fireDates = [monday, wednesday]
      notifs = createLocalNotifications(2)
      state = "2Week"

    }
    if index == 3 {
      var monday : NSDate = getDateOfSpecificDay(2)
      var wednesday : NSDate = getDateOfSpecificDay(4)
      var friday : NSDate = getDateOfSpecificDay(6)
      var saturday : NSDate = getDateOfSpecificDay(7)
      fireDates = [monday, wednesday, friday, saturday]
      notifs = createLocalNotifications(2)
      state = "4Week"

    }
    if index == 4 {
      var sunday : NSDate = getDateOfSpecificDay(1)
      var monday : NSDate = getDateOfSpecificDay(2)
      var tuesday : NSDate = getDateOfSpecificDay(3)
      var wednesday : NSDate = getDateOfSpecificDay(4)
      var thursday : NSDate = getDateOfSpecificDay(5)
      var friday : NSDate = getDateOfSpecificDay(6)
      var saturday : NSDate = getDateOfSpecificDay(7)
      fireDates = [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
      notifs = createLocalNotifications(7)
      state = "everyday"


    }
    saveSelectedSchedule(state)
    scheduleNotificationsWithFireDates(notifs, dates: fireDates)
    
  }
  
  func createLocalNotifications(numberOfDays:Int) -> NSArray {
    var arrayOfReminders : NSMutableArray = []
    for (var a = 0; a < numberOfDays; ++a) {
      var notif = UILocalNotification()
      notif.alertBody = "It's time to read!"
      notif.alertTitle = "Notification from Baha'i Readings"
      notif.repeatInterval = NSCalendarUnit.CalendarUnitWeekday
      arrayOfReminders.addObject(notif)
    }
    return arrayOfReminders
  }
  
  func getDateOfSpecificDay(day:Int) -> NSDate { // 1 = Sunday
    
    var desiredWeekday = day
    var weekDateRange : NSRange = NSCalendar.currentCalendar().maximumRangeOfUnit(.CalendarUnitWeekday)
    var daysInWeek : NSInteger = weekDateRange.length - weekDateRange.location + 1
    
    var dateComponents : NSDateComponents = NSCalendar.currentCalendar().components(.CalendarUnitWeekday, fromDate: NSDate())
    var currentWeekday : NSInteger = dateComponents.weekday
    var differenceDays : NSInteger = (desiredWeekday - currentWeekday + daysInWeek) % daysInWeek
    var daysComponents : NSDateComponents = NSDateComponents()
    
    daysComponents.day = differenceDays
    
    var resultDate : NSDate = NSCalendar.currentCalendar().dateByAddingComponents(daysComponents, toDate: NSDate(), options: nil)!
    
    return resultDate
  }
  
  func scheduleNotificationsWithFireDates(notifs:NSArray, dates:NSArray)
  {
    for (var a = 0; a < notifs.count ; a++)
    {
      var notif : UILocalNotification = notifs.objectAtIndex(a) as! UILocalNotification
      var date : NSDate = dates.objectAtIndex(a) as! NSDate
      notif.fireDate = date
      notif.applicationIconBadgeNumber++
      UIApplication.sharedApplication().scheduleLocalNotification(notif)
    }
  }
  
  func highlightSelectedSchedule(key:String) {
    if key == "never" {
      reminderSegment.selectedSegmentIndex = 0
      reminderDescription.text = sched0
    }
    if key == "1week" {
      reminderSegment.selectedSegmentIndex = 1
      reminderDescription.text = sched1
    }
    if key == "2week" {
      reminderSegment.selectedSegmentIndex = 2
      reminderDescription.text = sched2

    }
    if key == "4week" {
      reminderSegment.selectedSegmentIndex = 3
      reminderDescription.text = sched4

    }
    if key == "everyday" {
      reminderSegment.selectedSegmentIndex = 4
      reminderDescription.text = sched7
    }
  }
  
  func setCounterValues(val1:String,val2:String,val3:String) {
    self.readCount0.text = val1
  }
  
  func getSelectedSchedule()->String{
    //@jtan: TODO, refactor this
    return DataManager.getReminderKey()
  }
  
  func getCounterValues()->(String,String,String) {
    //@jtan: TODO, refactor this
    var k1 = DataManager.getCounterKey("counter1")
    var k2 = DataManager.getCounterKey("counter2")
    var k3 = DataManager.getCounterKey("counter3")
    return (k1,k2,k3)
  }
  
  func resetCounterValues() {
    //@jtan: TODO, refactor this
    DataManager.setCurrentKey("0", key: "counter1")
    DataManager.setCurrentKey("0", key: "counter2")
    DataManager.setCurrentKey("0", key: "counter3")
  }
  
  func saveSelectedSchedule(state:String) {
    //@jtan: TODO, refactor this
    DataManager.setCurrentKey(state, key: "schedule")
  }
  
}
