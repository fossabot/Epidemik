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
	var deviceToken: String?
	var introHolder: IntroHolder?

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
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		introHolder!.goToNext()
		
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		// Convert token to string
		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
		
		// Print it to conso le
		self.deviceToken = deviceTokenString

		//print("APNs device token: \(deviceTokenString)")
		
		// Persist it in your backend in case it's new
	}
	
	func sendDeviceTokenToServer(latitude: String, longitude: String) {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Notifications/recieveDeviceID.php")!)
		request.httpMethod = "POST"
		let postString = "deviceToken="+self.deviceToken! + "&latitude=" + latitude + "&longitude=" + longitude
		//let postString = ""
		request.httpBody = postString.data(using: .utf8)
		print("Sending")
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
		
			guard let _ = data, error == nil else {
				print("error=\(String(describing: error))")
				return
			}
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				print("response = \(String(describing: response))")
				return
			}
			let responseString = String(data: data!, encoding: .utf8)
			print(responseString ?? "")
		}
		task.resume()
		print(task.state.rawValue)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
	}


}

