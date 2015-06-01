//
//  ReminderView.swift
//  BahaiReadings
//
//  Created by James Tan on 6/1/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class ReminderView: UIViewController {

  @IBOutlet weak var optionsView: UIView!
  
  @IBOutlet weak var notOnOffLabel: UILabel!
  @IBOutlet weak var onOffDescription: UILabel!
  @IBOutlet weak var notOnOffSwitch: UISwitch!
  
  @IBOutlet weak var buttonMon: UIButton!
  @IBOutlet weak var buttonTue: UIButton!
  @IBOutlet weak var buttonWed: UIButton!
  @IBOutlet weak var buttonThr: UIButton!
  @IBOutlet weak var buttonFri: UIButton!
  @IBOutlet weak var buttonSat: UIButton!
  @IBOutlet weak var buttonSun: UIButton!
  @IBOutlet weak var buttonEveryDay: UIButton!
  
  @IBOutlet weak var buttonMorn: UIButton!
  @IBOutlet weak var buttonEvening: UIButton!
  @IBOutlet weak var buttonNoon: UIButton!
  @IBOutlet weak var buttonAfternoon: UIButton!
  @IBOutlet weak var buttonMidnight: UIButton!
  
  var onText : String = "Notifications are enabled. You will recieve a notification reminding you to read at the specified times and days."
  var offText : String = "Notifications are disabled. You won't recieve any reminders to read."
  
  
  class var shared : ReminderView {
    struct Static {
      static let instance : ReminderView = ReminderView()
    }
    return Static.instance
  }
  
//  struct frame {
//    static var presenter : ReminderPresenter? = nil
//  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  @IBAction func switchDidChange(sender: UISwitch) {
    
  }
  
  @IBAction func daySelected(sender: UIButton) {
    
  }
  
  @IBAction func timeSelected(sender: UIButton) {
  }
  
}
