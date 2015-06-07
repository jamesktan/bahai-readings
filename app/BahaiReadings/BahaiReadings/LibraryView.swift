//
//  LibraryView.swift
//  BahaiReadings
//
//  Created by James Tan on 6/6/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class LibraryView: UIViewController {

  @IBOutlet weak var libraryCarousel: iCarousel!
  
  @IBAction func testCloudkit(sender: AnyObject) {
    CloudKitService.getBookGalleryByCategory("tablet")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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

}
