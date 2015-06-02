//
//  ReaderView.swift
//  BahaiReadings
//
//  Created by James Tan on 5/30/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class ReaderView: UIViewController, UIGestureRecognizerDelegate, UIWebViewDelegate, UIScrollViewDelegate {
  
  @IBOutlet weak var readerWebView: UIWebView!
  
  @IBOutlet weak var settingsView: UIView!
  @IBOutlet weak var readerSettingsView: UIView!

  @IBOutlet weak var buttonSerif: UIButton!
  @IBOutlet weak var buttonSans: UIButton!
  
  @IBOutlet weak var buttonLight: UIButton!
  @IBOutlet weak var buttonDark: UIButton!
  @IBOutlet weak var buttonSunset: UIButton!
  @IBOutlet weak var buttonMidnight: UIButton!
  
  @IBOutlet weak var buttonOrientation: UIButton!
  
  @IBOutlet weak var sizeSlider: UISlider!
  
  @IBOutlet weak var bookTitleLabel: UILabel!
  @IBOutlet weak var bookPagesLabel: UILabel!
  
  var shadowView : UIView = UIView()
  
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
    
    shadowView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    shadowView.backgroundColor = UIColor.blackColor()
    shadowView.alpha = 0.5
    
    themeButtons = [buttonLight, buttonDark, buttonSunset, buttonMidnight]
    styleButtons = [buttonSerif, buttonSans]
    
    var tap = UITapGestureRecognizer(target: self, action: "showOrHideSettings")
    tap.numberOfTapsRequired = 1
    tap.numberOfTouchesRequired = 1
    tap.delegate = self
    self.readerWebView.addGestureRecognizer(tap)
    
    self.readerWebView.delegate = self
    self.readerWebView.scrollView.delegate = self
    
    var tap2 = UITapGestureRecognizer(target: self, action: "showOrHideSettings")
    tap2.numberOfTapsRequired = 1
    tap2.numberOfTouchesRequired = 1
    tap2.delegate = self
    self.shadowView.addGestureRecognizer(tap2)
    
    loadOrientation()
    loadWebDataForHandle(frame.currentBook)
    highlightStyleButton()
    highlightThemeButton()
    highlightOrientationButton()
    updateProgress()
    updateProgressLabels()
    updateTitleLabel()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    println("sizeOfWebView")
    var size = webView.scrollView.contentSize
    NSLog("%lf heightOfFrame %lf widthOfFrame", webView.frame.size.height, webView.frame.size.width)
    NSLog("%lf height %lf width SIZE", size.height, size.width)
    updateProgress()
    updateProgressLabels()
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    NSLog("%lf contentOffsetX, %lf contentOffsetY", scrollView.contentOffset.x, scrollView.contentOffset.y)
    frame.presenter!.setCurrentProgress(frame.currentBook, contentOffset: scrollView.contentOffset, contentSize: scrollView.contentSize)
    updateProgressLabels()
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
        self.view.insertSubview(self.shadowView, aboveSubview: self.readerWebView)
      } else {
        self.settingsView.alpha = 0
        self.readerSettingsView.alpha = 0
        self.shadowView.removeFromSuperview()
      }
    })

  }
  
  @IBAction func sliderDidMove(sender: UISlider) {
    sender.value = round(sender.value);
  }
  
  @IBAction func sliderDidEnd(sender: UISlider) {
    var index : Int = Int(sender.value)
    var sizes : NSArray = frame.presenter!.arrayOfReaderSizes()
    var selected : String = sizes.objectAtIndex(index) as! String
    frame.presenter!.selectSize(selected)
    loadWebDataForHandle(frame.currentBook)
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
  
  func loadOrientation() {
    var orientation = frame.presenter!.getOrientation()
    if orientation == "vertical" {
      self.readerWebView.paginationMode = UIWebPaginationMode.TopToBottom;
      self.readerWebView.paginationBreakingMode = UIWebPaginationBreakingMode.Page;
      self.readerWebView.gapBetweenPages = 0;
      self.readerWebView.scrollView.pagingEnabled = true;
      self.readerWebView.scrollView.bounces = true;
      self.readerWebView.scrollView.alwaysBounceVertical = false;
    } else {
      self.readerWebView.paginationMode = UIWebPaginationMode.LeftToRight;
      self.readerWebView.paginationBreakingMode = UIWebPaginationBreakingMode.Page;
      self.readerWebView.gapBetweenPages = 0;
      self.readerWebView.scrollView.pagingEnabled = true;
      self.readerWebView.scrollView.bounces = true;
      self.readerWebView.scrollView.alwaysBounceVertical = false;

    }
  }
  @IBAction func changeReaderOrientation(sender: UIButton) {
    if frame.presenter!.getOrientation() == "horizontal" {
      frame.presenter?.selectOrientation("vertical")
    } else {
      frame.presenter?.selectOrientation("horizontal")
    }
    loadOrientation()
    highlightOrientationButton()
    updateProgress()
    updateProgressLabels()
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
  
  func updateSlider() {
    var currentSlider : String = frame.presenter!.getSize()
    var sliderList : NSArray = frame.presenter!.arrayOfReaderSizes()
    var index = sliderList.indexOfObject(currentSlider)
    sizeSlider.value = Float(index)
  }
  
  func updateTitleLabel() {
    var handle : String = frame.currentBook
    var title : String = frame.presenter!.getCurrentBookTitle(frame.currentBook)
    bookTitleLabel.text = title
  }
  
  func updateProgress() {
    // Set the CUrrent Page
    var currentProgress : Float = frame.presenter!.getCurrentProgress(frame.currentBook)
    var offset = frame.presenter!.getOffsetFromProgress(currentProgress, contentSize: readerWebView.scrollView.contentSize)
    NSLog("%lf, %lf OFFSET", offset.x, offset.y)
    readerWebView.scrollView.contentOffset = offset
  }
  
  func updateProgressLabels() {
    var completedText : String = frame.presenter!.getProgressText(frame.currentBook, readerWebView:readerWebView)
    bookPagesLabel.text = completedText
  }
  
  func highlightOrientationButton() {
    var orientation : String = frame.presenter!.getOrientation()
    if orientation == "vertical" {
      buttonOrientation.selected = false
    } else {
      buttonOrientation.selected = true
    }
  }
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  
}
