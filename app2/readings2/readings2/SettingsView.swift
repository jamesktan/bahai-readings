//
//  SettingsView.swift
//  readings2
//
//  Created by James Tan on 1/14/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit
import MessageUI

class SettingsView: UITableViewController, MFMailComposeViewControllerDelegate {
  
  @IBOutlet weak var lightThemeSwitch: UISwitch!
  @IBOutlet weak var darkThemeSwitch: UISwitch!
  @IBOutlet weak var SepiaThemeSwitch: UISwitch!
  @IBOutlet weak var fontSizeSlider: UISlider!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Populate with Defaults
    let value = getReaderTheme()
    if value == 0 { lightThemeSwitch.setOn(true, animated: false)}
    if value == 1 { darkThemeSwitch.setOn(true, animated: false)}
    if value == 2 { SepiaThemeSwitch.setOn(true, animated: false)}

    // Populate the Font Size
    let size = getReaderFontSize()
    fontSizeSlider.value = size
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      if cell.tag == 100 {
        // About Triggered
        if let url = URL(string: "http://bahaireadings.com") {
          UIApplication.shared.open(url, options: [:])
        }
      }
      if cell.tag == 200 {
        // Contact Triggered
        sendEmail()
      }
      if cell.tag == 300 {
        // Reset All 
      }
      if cell.tag == 301 {
        
      }
    }
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  @IBAction func themeSelected(_ sender: UISwitch) {
    let switches : NSMutableArray = NSMutableArray(array:[lightThemeSwitch, darkThemeSwitch, SepiaThemeSwitch])
    
    switches.forEach { (item) in
      (item as! UISwitch).setOn(false, animated: true)
    }
    
    if !sender.isOn {
      sender.setOn(true, animated: true)
      if sender == lightThemeSwitch { saveReaderTheme(theme: 0) }
      if sender == darkThemeSwitch { saveReaderTheme(theme: 1) }
      if sender == SepiaThemeSwitch { saveReaderTheme(theme: 2) }
    }
    
  
  }
  
  @IBAction func sliderChanged(_ sender: UISlider) {
    let value = sender.value
    saveReaderFontSize(size: value)
  }
  
  func sendEmail() {
    if MFMailComposeViewController.canSendMail() {
      let mail = MFMailComposeViewController()
      mail.mailComposeDelegate = self
      mail.setToRecipients(["jamesktan@gmail.com"])
      mail.setMessageBody("", isHTML: true)
      present(mail, animated: true)
    } else {
      let alert = UIAlertController.alertWith(title: "Email Not Configured", text: "Your email is not configured so we cannot automatically send an email.", completion: {
        print("Done")
      })
      self.present(alert, animated: true, completion: nil )
    }
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    if result == .sent {
      let alert = UIAlertController.alertWith(title: "Feedback Sent!", text: "Your feedback is on it's way. Thank You!", completion: {
        print("Done")
      })
      self.present(alert, animated: true, completion: nil)
    } else {
      controller.dismiss(animated: true)
    }
  }
  
}

extension UIAlertController {
  static func alertWith(title:String, text:String, completion:@escaping (()->())) -> UIAlertController {
    let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
      completion()
    })
    alert.addAction(ok)
    return alert
  }
}
