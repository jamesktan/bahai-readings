//
//  PageView.swift
//  readings2
//
//  Created by James Tan on 1/14/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit
import WebKit

class PageView: UIViewController, UIScrollViewDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {
  
  var index : Int = 0
  
  @IBOutlet weak var readView: WKWebView!
  @IBOutlet weak var toolbar: UIToolbar!
  
  var castedParent : PageController? {
    get {
      return self.parent as? PageController
    }
  }
  var tableOfContents : TableOfContents? = nil
  var contents : String = ""
  var indicator : UIActivityIndicatorView!
  var tapGesture : UITapGestureRecognizer!
  var passage : String? = nil
  var highlightedText : [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    // Menu Button
    
    // Handle the Color Themes
    let theme = getReaderTheme()
    if theme == 0 {
      view.backgroundColor = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
    }
    if theme == 1 {
      view.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    }
    if theme == 2 {
      view.backgroundColor = UIColor(red: 247.0/255.0, green: 241.0/255.0, blue: 227.0/255.0, alpha: 1.0)
    }
    
    readView.navigationDelegate = self
    readView.alpha = 0.0
    readView.scrollView.delegate = self
    
    // Handle the Note
    let lookup = UIMenuItem(title: "Save Note", action: #selector(runGrok))
    UIMenuController.shared.menuItems = [lookup]
    
    
  }
  
  @objc func runGrok() {
    readView.evaluateJavaScript("window.getSelection().toString();") { (text, error) in
      self.readView.evaluateJavaScript("window.getSelection().getRangeAt(0).startOffset;", completionHandler: { (startIndex, error2) in
        
        RealmAdapter.createNote(creationDate: Date(), page: self.castedParent!.currentIndex, startIndex: startIndex as! Int, text: text as! String, writing: self.tableOfContents!.combined, note: "")
        let alert = UIAlertController.alertWith(title: "Text Added to Notes", text: "You may add a comment to your note in the Notes tab of the application", completion: {
          print("Done")
        })
        DispatchQueue.main.async {
          self.present(alert, animated: true, completion: nil)
        }
        
      })
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    
    // Continue Loading the Web Page
    
    if passage != nil {
      if contents.countInstances(of: "<span id = 'match'") == 0 {
        contents = NSString(string:contents).replacingOccurrences(of: passage!, with: "<span id='match' style='background-color: rgba(229,133,61,0.3);'>\(passage!)</span")
      }
    }
    readView.loadHTMLString(contents, baseURL: nil )
    indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    indicator.center = self.view.center
    indicator.startAnimating()
    view.addSubview(indicator)
    
    // Check the Color
    let theme = getReaderTheme()
    if theme == 1 {
      indicator.color = UIColor.white
    }
    
    // Check the Starred
//    if getStarredWritings().contains(tableOfContents!.fileName) {
////      starButton.image = UIImage(named: "star_filled.png")
//    } else {
////      starButton.image = UIImage(named: "star.png")
//    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.parent?.setToolbarItems(self.toolbar.items, animated: true)
    self.parent?.navigationItem.leftBarButtonItem = self.toolbar.items?.first!
    self.parent?.navigationItem.rightBarButtonItem = self.toolbar.items?.last!
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  func didScrollUp() {
    DispatchQueue.main.async {
      self.navigationController?.setToolbarHidden(false, animated: true)
      self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
  }
  
  func didScrollDown() {
    DispatchQueue.main.async {
      self.navigationController?.setToolbarHidden(true, animated: true)
      self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }

  var didEvaluateJS : Bool = false
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    indicator.stopAnimating()
    indicator.setAlpha(alpha: 0.0, duration: 0.3, completion: {
      self.indicator.removeFromSuperview()
      self.readView.setAlpha(alpha: 1.0, duration: 0.3, completion: nil)
    })
    
    
    if passage != nil && didEvaluateJS == false {
      // Go to this Position
      Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
        print(self.passage!)
        webView.evaluateJavaScript("window.scrollTo(0,$('span')[0].getBoundingClientRect().top)") { (result, error) in
          if error != nil {
            print(result ?? "")
          }
          print(error ?? "")
          DispatchQueue.main.async {
            self.didEvaluateJS = true
          }
        }
      })
    } else {
      if wasLaunchFromMain {
          if let progress = getWritingProgress(fileName: tableOfContents!.fileName) {
            if castedParent?.currentIndex == progress.page {
              let position = progress.position
              Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
                let positionY = CGFloat(position) * (webView.scrollView.contentSize.height - webView.scrollView.frame.height)
                webView.scrollView.contentOffset = CGPoint(x: 0, y: positionY)
              })
            }
          }

      }
    }
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
  {
    decisionHandler(.cancel)
  }
  
  var directionDown : Bool = false {
    didSet {
      if oldValue == false && directionDown == true {
        didScrollDown()

      } else if oldValue == true && directionDown == false {
        didScrollUp()
      }
    }
  }
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0){
      directionDown = false
    }
    else {
      directionDown = true
    }
  }

  func storePosition(scrollView:UIScrollView) {
    if let page = self.castedParent?.currentIndex {
      let position = scrollView.contentOffset.y
      let height = scrollView.contentSize.height - scrollView.frame.height
      let completed = position / height
      storeWritingProgress(fileName: tableOfContents!.fileName, page: page, position: Float(completed))
    }
  }
  
  @IBAction func pageForward(_ sender: UIBarButtonItem) {
    print(self.castedParent!.currentIndex)
    self.castedParent?.goTo(self.castedParent!.currentIndex + 1)
  }
  
  @IBAction func pageBackward(_ sender: UIBarButtonItem) {
    DispatchQueue.main.async {
      print(self.castedParent!.currentIndex)
      self.castedParent?.goTo(self.castedParent!.currentIndex - 1, isForward: false)
    }
  }
  
  @IBAction func bookmarkAction(_ sender: Any) {
    let alert = UIAlertController.alertWith(title: "Bookmark Created", text: "You've saved your current position!") {
      print("saved!")
    }
    self.present(alert, animated: true, completion: nil)
    storePosition(scrollView: self.readView.scrollView)
  }
  
  @IBAction func closeReader() {
    parent?.dismiss(animated: true, completion: nil)
  }

  @IBAction func shareAction(_ sender: UIBarButtonItem) {
    let shareItem : String = "\(self.tableOfContents?.combined ?? "") \n\n \(self.tableOfContents?.contents.joined(separator: "\n") ?? "")"
    let activity = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
    self.present(activity, animated: true, completion: nil)
  }
  
  
  @IBAction func showTableOfContents(_ sender: UIBarButtonItem) {
    self.castedParent!.showTableOfContents(self.tableOfContents!)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
