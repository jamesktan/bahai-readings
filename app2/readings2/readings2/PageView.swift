//
//  PageView.swift
//  readings2
//
//  Created by James Tan on 1/14/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit
import WebKit

class PageView: UIViewController, UIScrollViewDelegate, WKNavigationDelegate {
  
  @IBOutlet weak var readView: WKWebView!
  
  var contents : String = ""
  var indicator : UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.readView.navigationDelegate = self
    self.readView.alpha = 0.0
  }
  override func viewWillAppear(_ animated: Bool) {
    self.readView.loadHTMLString(contents, baseURL: nil )
    indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    indicator.center = self.view.center
    indicator.startAnimating()
    self.view.addSubview(indicator)
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    indicator.stopAnimating()
    UIView.animate(withDuration: 0.3, animations: {
      self.indicator.alpha = 0.0
    }, completion: { finished in
      self.indicator.removeFromSuperview()
      UIView.animate(withDuration: 0.3, animations: {
        self.readView.alpha = 1.0
      })
      
    })
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

