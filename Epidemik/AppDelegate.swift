//
//  AppDelegate.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/15/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var accCreation: LoginScreen?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		//sendDeviceTokenToServer()
		//sendTestPOST()
		return true
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		accCreation?.createAccount(deviceID: "null")
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
		accCreation?.createAccount(deviceID: deviceTokenString)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
	}

	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		completionHandler(shouldPerformActionFor(shortcutItem: shortcutItem, application: application))
	}
	
	private func shouldPerformActionFor(shortcutItem: UIApplicationShortcutItem, application: UIApplication) -> Bool {
		let shortcutType = shortcutItem.type
		let shortcutIdentifier = shortcutType.components(separatedBy: ".").last
		switch shortcutIdentifier! {
		case "HealthyButton":
			Reporting.amHealthy()
			refreshSicknessScreen(application: application)
		case "CommonColdButton":
			Reporting.amSick(diseaseName: "Common Cold")
			refreshSicknessScreen(application: application)
		case "FluButton":
			Reporting.amSick(diseaseName: "Flu")
			refreshSicknessScreen(application: application)
		default:
			refreshSicknessScreen(application: application)
		}
		return false
	}
	
	func refreshSicknessScreen(application: UIApplication) {
		let vc = application.keyWindow?.rootViewController as! ViewController
		vc.refreshSicknessScreen()
	}
	
	func displayDiseaseSelector(application: UIApplication) {
		let vc = application.keyWindow?.rootViewController as! ViewController
		vc.refreshSicknessScreen()
		vc.displayDiseaseSelector()
	}
}

