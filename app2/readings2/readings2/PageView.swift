//
//  PageView.swift
//  readings2
//
//  Created by James Tan on 1/14/18.
//  Copyright © 2018 James Tan. All rights reserved.
//

import UIKit
import WebKit
import ActionSheetPicker_3_0

class PageView: UIViewController, UIScrollViewDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {
  
  @IBOutlet weak var readView: WKWebView!
  @IBOutlet weak var toolbar: UIToolbar!

  var castedParent : PagesControllerHidden? {
    get {
      return self.parent as? PagesControllerHidden
    }
  }
  var tableOfContents : TableOfContents? = nil
  var contents : String = ""
  var indicator : UIActivityIndicatorView!
  var tapGesture : UITapGestureRecognizer!
  var isToolBarHidden : Bool = true

  override func viewDidLoad() {
    super.viewDidLoad()
    readView.navigationDelegate = self
    readView.alpha = 0.0
    readView.scrollView.delegate = self
    
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
    
    toolbar.alpha = 0.0
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    readView.loadHTMLString(contents, baseURL: nil )
    indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    indicator.center = self.view.center
    indicator.startAnimating()
    view.addSubview(indicator)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if !isToolBarHidden {
      didTap()
    }
  }
  
  @objc func didTap() {
    if isToolBarHidden { toolbar.setAlpha(alpha: 1.0) }
    else { toolbar.setAlpha(alpha:0.0) }
    isToolBarHidden = !isToolBarHidden
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    indicator.stopAnimating()
    indicator.setAlpha(alpha: 0.0, duration: 0.3, completion: {
      self.indicator.removeFromSuperview()
      self.readView.setAlpha(alpha: 1.0, duration: 0.3, completion: nil)
    })
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let page = self.castedParent?.currentIndex
    let position = scrollView.contentOffset.y
    let height = scrollView.contentSize.height - scrollView.frame.height
    let completed = position / height
    storeWritingProgress(fileName: tableOfContents!.fileName, page: page!, position: Float(completed))
  }
  
  
  @IBAction func closeReader() {
    parent?.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func favoriteWriting () {
    let list = getStarredWritings()
    if list.contains(tableOfContents!.fileName) {
      let result = removeStarredWriting(fileName: tableOfContents!.fileName)
      print("Removal Result: \(result)")
    } else {
      saveStarredWriting(fileName: tableOfContents!.fileName)
    }
  }
  
  @IBAction func showTableOfContents(_ sender: UIBarButtonItem) {
    ActionSheetMultipleStringPicker.show(withTitle: self.tableOfContents!.combined, rows: [
      self.tableOfContents!.contents,
      ], initialSelection: [self.castedParent!.currentIndex], doneBlock: {
        picker, indexes, values in
        if let points = indexes as? [Int] {
          let goTo = points.first!
          self.castedParent?.goTo(goTo)
        }
        return
    }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
