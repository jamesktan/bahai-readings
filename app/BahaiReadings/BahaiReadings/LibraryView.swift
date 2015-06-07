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
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    libraryCarousel.delegate = self
    libraryCarousel.dataSource = self
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
    return 0
  }
  
  func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
    return UIView()
  }
  
  func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
    
  }

}
