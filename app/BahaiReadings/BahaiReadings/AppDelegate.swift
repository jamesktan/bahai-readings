//
//  AppDelegate.swift
//  BahaiReadings
//
//  Created by James Tan on 5/30/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // Override point for customization after application launch.
    CloudKitService.setupCloudService()
    
    var readerView : ReaderView = ReaderView.shared
    var readerPresent : ReaderPresenter = ReaderPresenter()
    var readerInteract : ReaderInteractor = ReaderInteractor()
    readerPresent.vc = readerView
    readerPresent.interactor = readerInteract
    readerInteract.presenter = readerPresent
    ReaderView.frame.presenter = readerPresent
    
    var currentRead : String = DataManager.getCurrentlyReading()
    if currentRead != "nothing" {
      ReaderView.frame.currentBook = currentRead
    }
    
    var notification = application.applicationIconBadgeNumber
    if notification != 0 {
      var counterSameDay : NSString = DataManager.getCounterKey("counter1") as NSString
      var newVal = counterSameDay.integerValue + 1
      DataManager.setCurrentKey(String(format: "%d", newVal), key: "counter1")
      application.applicationIconBadgeNumber = 0
    }
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    
//    var fireDate : NSDate = notification.fireDate!
//    var distance : NSTimeInterval = fireDate.timeIntervalSinceNow
//    var hours : NSInteger = Int(Float(distance) / Float(3600.0))
//    if hours > -24 {
//      var counterSameDay : NSString = DataManager.getCounterKey("counter2") as NSString
//      var newVal = counterSameDay.integerValue + 1
//      DataManager.setCurrentKey(String(format: "%d", newVal), key: "counter2")
//      application.applicationIconBadgeNumber = 0
//      return
//
//    }
//    if hours > -48 {
//      var counterSameDay : NSString = DataManager.getCounterKey("counter3") as NSString
//      var newVal = counterSameDay.integerValue + 1
//      DataManager.setCurrentKey(String(format: "%d", newVal), key: "counter3")
//      application.applicationIconBadgeNumber = 0
//      return
//      
//    }
//    if hours > -72 {
//      application.applicationIconBadgeNumber = 0
//      return
//    }

    var counterSameDay : NSString = DataManager.getCounterKey("counter1") as NSString
    var newVal = counterSameDay.integerValue + 1
    DataManager.setCurrentKey(String(format: "%d", newVal), key: "counter1")
    application.applicationIconBadgeNumber = 0
  }

}

