//
//  ReaderView.swift
//  BahaiReadings
//
//  Created by James Tan on 5/30/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class ReaderView: UIViewController, UIGestureRecognizerDelegate {
  
  @IBOutlet weak var readerWebView: UIWebView!
  @IBOutlet weak var settingsView: UIView!
  @IBOutlet weak var readerSettingsView: UIView!

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
    
    var urlString = "https://s3-us-west-2.amazonaws.com/bahai-reading/Epistle+To+The+Son+of+the+Wolf.html"
    var url = NSURL(string: urlString)
    var contents = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)
    readerWebView.loadHTMLString(contents as String!, baseURL: nil)
    
    var tap = UITapGestureRecognizer(target: self, action: "showOrHideSettings")
    tap.numberOfTapsRequired = 1
    tap.numberOfTouchesRequired = 1
    tap.delegate = self
    self.readerWebView.addGestureRecognizer(tap)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    

  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
  }
  
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    if([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
//      
//      UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer*)otherGestureRecognizer;
//      if(tapRecognizer.numberOfTapsRequired == 2 && tapRecognizer.numberOfTouchesRequired == 1){
//        
//        //this disalbes and cancels all other singleTouchDoubleTap recognizers
//        // default is YES. disabled gesture recognizers will not receive touches. when changed to NO the gesture recognizer will be cancelled if it's currently recognizing a gesture
//        otherGestureRecognizer.enabled = NO;
//        
//      }
//      
//    }

    if otherGestureRecognizer.isKindOfClass(UITapGestureRecognizer) {
      var tapRecognizer : UITapGestureRecognizer = otherGestureRecognizer as! UITapGestureRecognizer
      if tapRecognizer.numberOfTapsRequired == 1 && tapRecognizer.numberOfTouchesRequired == 1 {
//        showOrHideSettings()
        otherGestureRecognizer.enabled = false
      }
    }
    
    return true
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  @IBAction func showOrHideReaderSettings(sender: AnyObject) {
    UIView.animateWithDuration(0.3, animations: {
      if self.readerSettingsView.alpha == 0 {
        self.readerSettingsView.alpha = 1
      } else {
        self.readerSettingsView.alpha = 0
      }
    })

  }

  func showOrHideSettings() {
    UIView.animateWithDuration(0.3, animations: {
      if self.settingsView.alpha == 0 {
        self.settingsView.alpha = 1
      } else {
        self.settingsView.alpha = 0
      }
    })

  }
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
