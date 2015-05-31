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
  
  func selectStyle(key:String) {
    interactor!.selectStyle(key)
  }
  
  func selectTheme(key:String) {
    interactor!.selectTheme(key)
  }
  
  func selectSize(key:String) {
    interactor!.selectSize(key)
  }
}
