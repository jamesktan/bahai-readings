//
//  AboutView.swift
//  BahaiReadings
//
//  Created by James Tan on 6/6/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit
import MessageUI

class AboutView: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  @IBAction func createFeedback(sender: UIButton) {
    var title : String = "Baha'i Readings"
    var recipient : NSArray = ["jamesktan@gmail.com"]
    var body : String = "<h3>Baha'i Readings Feedback:</h3><br>"
    var mfc = MFMailComposeViewController()
    mfc.mailComposeDelegate = self
    mfc.setToRecipients(recipient as [AnyObject])
    mfc.setSubject(title)
    mfc.setMessageBody(body, isHTML: true)
    presentViewController(mfc, animated: true, completion: {
      
    })
    
  }
  
  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    if result.value == MFMailComposeResultSent.value {
      UIAlertView(title: "Sent", message: "Your feedback is greatly appreciated! Thank you.", delegate: nil, cancelButtonTitle: "Continue").show()
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func showAcknowledgements(sender: UIButton) {
    performSegueWithIdentifier("showThanks", sender: self)
  }
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
