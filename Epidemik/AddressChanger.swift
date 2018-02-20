//
//  AddressChanger.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/13/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import UserNotifications

public class ADDRESS {
	
	public static var FILE_NAME = "address.epi"
	
	public static func askForNewAddress(message: String, currentView: UIView) {
		let alert = UIAlertController(title: "Address", message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
			let textf1 = alert.textFields![0] as UITextField
			self.convertToCordinates(address: textf1.text!, currentView: currentView)
		}))
		alert.addTextField(configurationHandler: {(textField: UITextField) in
			textField.placeholder = "1 Main St. New York, NY"
			textField.isSecureTextEntry = false
		})
		UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
	}
	
	public static func convertToCordinates(address: String, currentView: UIView) {
		if (address != "") {
			FileRW.writeFile(fileName: ADDRESS.FILE_NAME, contents: address)
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
				if(error != nil) {
					self.setError(currentView: currentView)
				} else if let buffer = placemarks?[0] {
					let location = buffer.location;
					currentView.endEditing(true)
					let vc = UIApplication.shared.delegate?.window??.rootViewController as! ViewController
					vc.updateTrends()
					let appDelegate = UIApplication.shared.delegate as! AppDelegate
					appDelegate.sendDeviceTokenToServer(latitude: String(describing: location!.coordinate.latitude), longitude: String(describing: location!.coordinate.longitude), viewController:  UIApplication.shared.delegate?.window??.rootViewController as? ViewController)
				} else {
					self.setError(currentView: currentView)
				}
			})
		} else {
			setError(currentView: currentView)
		}
	}
	
	public static func setError(currentView: UIView) {
		askForNewAddress(message: "Please Enter A Valid Address", currentView: currentView)
	}
	
	public static func updateDeviceToken() {
		UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]){ (granted, error) in }
		UIApplication.shared.registerForRemoteNotifications()
	}
	
}


