//
//  ReaderPresenter.swift
//  BahaiReadings
//
//  Created by James Tan on 5/31/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class ReaderPresenter: NSObject {
  
  var vc : ReaderView? = nil
  var interactor : ReaderInteractor? = nil

  func arrayOfReaderThemes() -> NSArray {
    return interactor!.arrayOfReaderThemes()
  }
  
  func arrayOfReaderStyles() -> NSArray {
    return interactor!.arrayOfReaderStyles()
  }
  
  func arrayOfReaderSizes() -> NSArray {
    return interactor!.arrayOfReaderSizes()
  }
  
  func htmlForBook(bookHandle:String) -> String {
    var contentsNoStyle : String = interactor!.htmlForBook(bookHandle)
    var styleTag : String = interactor!.htmlForCurrentStyle()
    var contents : String = contentsNoStyle.stringByReplacingOccurrencesOfString("<style></style>", withString: styleTag, options: nil, range: nil)
    return contents
  }
  
  func getStyle() -> String {
    return interactor!.getCurrentStyle()
  }
  func getTheme() -> String {
    return interactor!.getCurrentTheme()
  }
  func getSize() -> String {
    return interactor!.getCurrentSize()
  }
  func getOrientation()->String{
    return interactor!.getCurrentOrientation()
  }
  
  
  func selectStyle(key:String) {
    interactor!.selectStyle(key)
  }
  
  func selectTheme(key:String) {
    interactor!.selectTheme(key)
  }
  
  func selectSize(key:String) {
    interactor!.selectSize(key)
  }
  func selectOrientation(key:String) {
    interactor!.selectOrientation(key)
  }
  
  // MARK: Progress
  
  func getCurrentProgress(bookHandle:String) -> Float {
    return interactor!.getCurrentProgress(bookHandle)
  }
  
  func getOffsetFromProgress(percentage:Float, contentSize: CGRect) -> CGPoint {
    if contentSize.size.width > contentSize.size.height {
      // Left To Right Orientation
      var x = Float(contentSize.size.width) * percentage
      var point = CGPoint(x: CGFloat(x), y: CGFloat(0))
      return point
    } else {
      var y = Float(contentSize.size.height) * percentage
      var point = CGPoint(x:CGFloat(0), y:CGFloat(y))
      return point
    }
  }
  
  func readPagesFromContentOffsetAndSize(offset:Float, contentSize:CGSize)-> Int {
    
    return 0
  }
  func totalPagesFromContentSize(webViewSize:CGSize, contentSize: CGSize) -> Int {
    return 0
  }
  func setCurrentProgress(bookHandle:String, contentOffset:CGPoint, contentSize:CGSize) {
    
  }
}
