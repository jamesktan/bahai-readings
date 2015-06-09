//
//  LibraryView.swift
//  BahaiReadings
//
//  Created by James Tan on 6/6/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class LibraryView: UIViewController, iCarouselDataSource, iCarouselDelegate {

  @IBOutlet weak var libraryCarousel: iCarousel!
    
  @IBOutlet weak var bookView: UIView!
  @IBOutlet weak var cover: UIImageView!
  @IBOutlet weak var bookTitle: UILabel!
  @IBOutlet weak var author: UILabel!
  @IBOutlet weak var completed: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    libraryCarousel.delegate = self
    libraryCarousel.dataSource = self
    libraryCarousel.type = iCarouselType.Cylinder
  }

  override func viewWillAppear(animated: Bool) {
    self.libraryCarousel.reloadData()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
    
  @IBAction func searchForBooks(sender: UIButton) {
    performSegueWithIdentifier("showGallery", sender: self)
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
    BookService.findLocalBooks()
    var count = BookService.container.libraryFiles.count
    return count
  }
  
  func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
    // Get the Data
    var array : NSArray = BookService.container.libraryFiles as NSArray
    var key : String = array.objectAtIndex(index) as! String
    var bookDict : NSDictionary = BookService.getBookFromFile(key)
    var authorVal = bookDict.objectForKey("bookAuthor") as! String
    var coverVal = bookDict.objectForKey("bookCover") as! String
    var titleVal = bookDict.objectForKey("bookTitle") as! String
    var progressVal = bookDict.objectForKey("bookProgress") as! String
    
    
    var v = UIView(frame: CGRect(x: 0, y: 0, width: 256, height: 386))
   
    var i = UIImage(named: coverVal)
    var iv = UIImageView(frame: v.frame)
    iv.image = i
    
    var labelView = UIView(frame: CGRect(x: 0, y: 304, width: 240, height: 57))
    labelView.backgroundColor = UIColor.whiteColor()
    
    var labelTitle : UILabel = UILabel(frame: CGRect(x: 8, y: 8, width: 224, height: 21))
    labelTitle.font = bookTitle.font
    labelTitle.text = titleVal
    
    var labelBody : UILabel = UILabel(frame: CGRect(x: 8, y: 31, width: 224, height: 21))
    labelBody.font = author.font
    labelBody.text = "by: " + authorVal
    
    var labelProgress : UILabel = UILabel(frame: CGRect(x: 136, y: 31, width: 96, height: 21))
    labelProgress.font = completed.font
    
    // process progress
    var progressString : NSString = progressVal as NSString
    var progressFloat : Float = progressString.floatValue * 100
    labelProgress.text = String(format:"%.1lf%% completed",progressFloat)

    labelView.addSubview(labelTitle)
    labelView.addSubview(labelBody)
    labelView.addSubview(labelProgress)
    v.addSubview(iv)
    v.addSubview(labelView)

    return v
  }
  
  func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
    var array : NSArray = BookService.container.libraryFiles as NSArray
    var key : String = array.objectAtIndex(index) as! String

    ReaderView.frame.currentBook = key
    
    DataManager.setCurrentKey(key, key: "currentlyReading")
    
    self.tabBarController?.selectedIndex = 0
  }

  func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
    if option == iCarouselOption.Spacing {
      return 1.1
    }
    return value
  }
  
}
