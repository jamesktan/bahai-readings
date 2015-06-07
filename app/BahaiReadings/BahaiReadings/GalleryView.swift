//
//  GalleryView.swift
//  BahaiReadings
//
//  Created by James Tan on 6/6/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class GalleryView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  @IBOutlet weak var galleryCollection: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    galleryCollection.delegate = self
    galleryCollection.dataSource = self
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

  // MARK: UICollectionView Delegate Methods
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell : GalleryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("BookCell", forIndexPath: indexPath) as! GalleryCollectionViewCell    
    // Configure the cell
    return cell
  }



  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
  }
  
}
