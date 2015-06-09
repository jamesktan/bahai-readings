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
  
  func htmlForBook(bookHandle:String?) -> String {
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
  func getCurrentBookTitle(bookHandle:String?)->String {
    return interactor!.getCurrentBookTitle(bookHandle)
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
  
  func getCurrentProgress(bookHandle:String?) -> Float {
    return interactor!.getCurrentProgress(bookHandle)
  }
  
  func getOffsetFromProgress(percentage:Float, contentSize: CGSize, webViewSize:CGSize) -> CGPoint {
    if contentSize.width > contentSize.height {
      // Left To Right Orientation
      var x = (Float(contentSize.width) * percentage) - Float(webViewSize.width)
      if x < 0 { x = 0 }
      var point = CGPoint(x: CGFloat(x), y: CGFloat(0))
      return point
    } else {
      var y = (Float(contentSize.height) * percentage) - Float(webViewSize.height)
      if y < 0 { y = 0 }
      var point = CGPoint(x:CGFloat(0), y:CGFloat(y))
      return point
    }
  }
  
  func readPagesFromOffsetAndSize(offset:Float, webViewSize:CGSize, contentSize:CGSize)-> Int {
    if contentSize.height > contentSize.width {
      // Top to Bottom
      var count = Int((offset * Float(contentSize.height+webViewSize.height))/Float(webViewSize.height))
      println(count)
      if count == 0 { count = 1 }
      return count - 1
    } else {
      var count = Int((offset * Float(contentSize.width+webViewSize.width))/Float(webViewSize.width))
      println(count)
      if count == 0 { count = 1 }
      return count - 1
    }
  }
  
  func totalPagesFromContentSize(webViewSize:CGSize, contentSize: CGSize) -> Int {
    if contentSize.height > contentSize.width {
      // To to Bottom
      var count = Int(contentSize.height / webViewSize.height)
      return count
    } else {
      var count = Int(contentSize.width / webViewSize.height)
      return count
    }
  }
  
  func setCurrentProgress(bookHandle:String?, contentOffset:CGPoint, contentSize:CGSize, webViewSize:CGSize) {
    var percentage : Float = 0.0
    percentage = (contentSize.height > contentSize.width) ? Float((contentOffset.y+webViewSize.height ) / contentSize.height) : Float((contentOffset.x + webViewSize.width ) / contentSize.width)
    interactor!.setCurrentProgress(bookHandle, progress: percentage)
  }
  
  
  func getProgressText(bookHandle:String?, readerWebView:UIWebView)->String {
    var currentProgress : Float = getCurrentProgress(bookHandle)
    var totalPages : Int = self.totalPagesFromContentSize(readerWebView.frame.size, contentSize: readerWebView.scrollView.contentSize)
    var completedPages : Int = self.readPagesFromOffsetAndSize(currentProgress, webViewSize: readerWebView.frame.size, contentSize:readerWebView.scrollView.contentSize)
    var completedString : String = String(format: "%d of %d pages completed", arguments: [completedPages, totalPages])
    return completedString
  }
}
