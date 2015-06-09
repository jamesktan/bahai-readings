//
//  GalleryView.swift
//  BahaiReadings
//
//  Created by James Tan on 6/6/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit
import CloudKit

class GalleryView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  @IBOutlet weak var galleryCollection: UICollectionView!
  
  override func viewWillAppear(animated: Bool) {
    if CloudKitService.container.galleryDownloaded == false {
      CloudKitService.setupCloudService()
    }
    galleryCollection.reloadData()
  }
  
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
    if CloudKitService.container.galleryDownloaded == true {
      return CloudKitService.container.galleryList.count
    } else {
      return 1
    }
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell : GalleryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("BookCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
    
    // Configure the cell
    if CloudKitService.container.galleryDownloaded == true {
      var tempList : NSArray = CloudKitService.container.galleryList as NSArray
      var book : CKRecord = tempList.objectAtIndex(indexPath.row) as! CKRecord
      cell.bookTitle.text = (book.objectForKey("bookTitle") as! String)
      cell.bookAuthor.text = "by: " + (book.objectForKey("bookAuthor") as! String)
      cell.bookDescription.text = (book.objectForKey("bookNotes") as! String)
      cell.bookCover.image = UIImage(named: (book.objectForKey("bookCoverURL") as! String) + ".jpg" )
      
      cell.hiddenBookHandle = (book.objectForKey("bookHandle") as! String)
      cell.hiddenBookURL = (book.objectForKey("bookURL") as! String)
      cell.hiddenCoverURL = (book.objectForKey("bookCoverURL") as! String) + ".jpg"
      cell.hiddenBookAuthor = (book.objectForKey("bookAuthor") as! String)

    } else {
      cell.bookDescription.text = "You are seeing this because you did not activate iCloud. Go to your Settings App and login to iCloud to continue."
      cell.bookAuthor.hidden = true
      cell.bookTitle.hidden = true
      cell.bookCover.hidden = true
      cell.buttonDownload.hidden = true
      
    }
    
    
    return cell
  }



  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
  }
  
}
