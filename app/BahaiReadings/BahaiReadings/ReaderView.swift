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

  @IBOutlet weak var buttonSerif: UIButton!
  @IBOutlet weak var buttonSans: UIButton!
  
  @IBOutlet weak var buttonLight: UIButton!
  @IBOutlet weak var buttonDark: UIButton!
  @IBOutlet weak var buttonSunset: UIButton!
  @IBOutlet weak var buttonMidnight: UIButton!
  
  var themeButtons : NSArray = []
  var styleButtons : NSArray = []
  
  class var shared : ReaderView {
    struct Static {
      static let instance : ReaderView = ReaderView()
    }
    return Static.instance
  }
  
  struct frame {
    static var presenter : ReaderPresenter? = nil
    static var currentBook : String = "Epistle+To+The+Son+of+the+Wolf"
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    themeButtons = [buttonLight, buttonDark, buttonSunset, buttonMidnight]
    styleButtons = [buttonSerif, buttonSans]
    
    var tap = UITapGestureRecognizer(target: self, action: "showOrHideSettings")
    tap.numberOfTapsRequired = 1
    tap.numberOfTouchesRequired = 1
    tap.delegate = self
    self.readerWebView.addGestureRecognizer(tap)
    
    loadWebDataForHandle(frame.currentBook)
    highlightStyleButton()
    highlightThemeButton()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if otherGestureRecognizer.isKindOfClass(UITapGestureRecognizer) {
      var tapRecognizer : UITapGestureRecognizer = otherGestureRecognizer as! UITapGestureRecognizer
      if tapRecognizer.numberOfTapsRequired == 1 && tapRecognizer.numberOfTouchesRequired == 1 {
        otherGestureRecognizer.enabled = false
      }
    }
    
    return true
  }
  
  func loadWebDataForHandle(currentBook : String) {
    
    // Get the HTML Content
    var contents = frame.presenter!.htmlForBook(currentBook)
    readerWebView.loadHTMLString(contents as String!, baseURL: nil)
    
  }
  
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
        self.readerSettingsView.alpha = 0
      }
    })

  }
  
  @IBAction func sliderDidMove(sender: UISlider) {
  }
  
  @IBAction func changeFontStyle(sender: UIButton) {
    var styles : NSArray = frame.presenter!.arrayOfReaderStyles()
    var selected : String = styles.objectAtIndex(sender.tag) as! String
    frame.presenter!.selectStyle(selected)
    loadWebDataForHandle(frame.currentBook)
    highlightStyleButton()
  }
  
  @IBAction func changeFontTheme(sender: UIButton) {
    var themes : NSArray = frame.presenter!.arrayOfReaderThemes()
    var selected : String = themes.objectAtIndex(sender.tag) as! String
    frame.presenter!.selectTheme(selected)
    loadWebDataForHandle(frame.currentBook)
    highlightThemeButton()
  }
  
  @IBAction func changeReaderOrientation(sender: UIButton) {
    if readerWebView.paginationMode == UIWebPaginationMode.LeftToRight {
      sender.selected = false
      self.readerWebView.paginationMode = UIWebPaginationMode.TopToBottom;
      self.readerWebView.paginationBreakingMode = UIWebPaginationBreakingMode.Page;
      self.readerWebView.gapBetweenPages = 0;
      self.readerWebView.scrollView.pagingEnabled = true;
      self.readerWebView.scrollView.bounces = true;
      self.readerWebView.scrollView.alwaysBounceVertical = false;

    } else {
      sender.selected = true
      self.readerWebView.paginationMode = UIWebPaginationMode.LeftToRight;
      self.readerWebView.paginationBreakingMode = UIWebPaginationBreakingMode.Page;
      self.readerWebView.gapBetweenPages = 0;
      self.readerWebView.scrollView.pagingEnabled = true;
      self.readerWebView.scrollView.bounces = true;
      self.readerWebView.scrollView.alwaysBounceVertical = false;

    }

  }
  
  func highlightStyleButton() {
    // Set the Selected Buttons
    for button in styleButtons {
      var ub : UIButton = button as! UIButton
      ub.selected = false
    }
    var currentStyle : String = frame.presenter!.getStyle()
    var styleList : NSArray = frame.presenter!.arrayOfReaderStyles()
    var index = styleList.indexOfObject(currentStyle)
    var button : UIButton = styleButtons.objectAtIndex(index) as! UIButton
    button.selected = true

  }
  
  func highlightThemeButton() {
    for button in themeButtons {
      var ub : UIButton = button as! UIButton
      ub.selected = false
    }
    var currentTheme : String = frame.presenter!.getTheme()
    var themeList : NSArray = frame.presenter!.arrayOfReaderThemes()
    var index = themeList.indexOfObject(currentTheme)
    var button : UIButton = themeButtons.objectAtIndex(index) as! UIButton
    button.selected = true
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  
}
