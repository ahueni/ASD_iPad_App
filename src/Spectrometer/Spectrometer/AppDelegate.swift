//
//  AppDelegate.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // config object
    var config: SpectrometerConfig? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "OpenSans", size: 15)!]
        let attributesTabBarButton = [NSFontAttributeName:UIFont(name: "OpenSans", size: 15)!]
        
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
        UISearchBar.appearance().placeholder = "Suchen"
        
        let asdfasd = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        asdfasd.font = UIFont(name: "Open Sans", size: 13)
        
        let cancelButtonText = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        cancelButtonText.title = "Schliessen"
        
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: UIControlState.normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(attributesTabBarButton, for: .normal)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self]).setTitleTextAttributes(attributesTabBarButton, for: UIControlState.normal)
        
        let blubb = UINavigationBar.appearance()
        blubb.titleTextAttributes = attributes
        
        // create Measurement folder if not exists
        let fileManager:FileManager = FileManager.default
        let documentsPath:URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let measurementPath:URL = documentsPath.appendingPathComponent("Messungen", isDirectory: true)
        
        print("Documents Folder: " + documentsPath.absoluteString)
        
        var isDirectory: ObjCBool = false
        let exists:Bool = fileManager.fileExists(atPath: measurementPath.relativePath, isDirectory: &isDirectory)
        
        if (!exists) {
            do {
                try fileManager.createDirectory(at: measurementPath, withIntermediateDirectories: false, attributes: nil)
            } catch { /* do nothing */ }
        }
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var rootViewController = self.window?.rootViewController
        
        while let next = rootViewController?.presentedViewController {
            rootViewController = next
        }
        
        let alert = UIAlertController(title: "Datei importiert", message: "Die Datei wurde erfolgreich Importiert. Sie können die INI-Datei nun einem Spektrometer zuweisen.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        rootViewController?.present(alert, animated: true, completion: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("Now in Background")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Wieder aktiv")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Spectrometer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                print("Context Saved")
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

