//
//  GalleryView.swift
//  BahaiReadings
//
//  Created by James Tan on 6/6/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class GalleryView: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
    
  @IBAction func goToLibrary(sender: UIButton) {
    self.navigationController?.popViewControllerAnimated(true)
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

}
