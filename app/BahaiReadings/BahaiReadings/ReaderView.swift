//
//  ReaderView.swift
//  BahaiReadings
//
//  Created by James Tan on 5/30/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class ReaderView: UIViewController {
  
  @IBOutlet weak var readerWebView: UIWebView!
  @IBOutlet weak var settingsView: UIView!
  @IBOutlet weak var navView: UIView!

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
    
    var urlString = "https://s3-us-west-2.amazonaws.com/bahai-reading/Epistle+To+The+Son+of+the+Wolf.html"
    var url = NSURL(string: urlString)
    var contents = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)
    readerWebView.loadHTMLString(contents as String!, baseURL: nil)
    
    var tap = UITapGestureRecognizer()
    tap.numberOfTapsRequired = 1
    tap.addTarget(readerWebView, action: "showOrHideSettings")
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    

  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  func showOrHideSettings() {
    UIView.animateWithDuration(0.3, animations: {
      if self.settingsView.alpha == 0 {
        self.settingsView.alpha = 1
        self.navView.alpha = 1
      } else {
        self.settingsView.alpha = 0
        self.navView.alpha = 0
      }
    })

  }
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
