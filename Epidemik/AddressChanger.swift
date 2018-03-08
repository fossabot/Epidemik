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

class ADDRESS {
	
	public static var FILE_NAME = "address.epi"
	
	public static func askForNewAddress(message: String) {
		Asker.ask(title: "Address", placeHolder: "1 Main St. New York, NY", message: message, isSecure: false, resp: AddressResponse())
	}
	
	public static func convertToCordinates(address: String) {
		if (address != "") {
			FileRW.writeFile(fileName: ADDRESS.FILE_NAME, contents: address)
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
				if let buffer = placemarks?[0] {
					let location = buffer.location;
					UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
					let vc = UIApplication.shared.delegate?.window??.rootViewController as! ViewController
					vc.updateTrends()
					let appDelegate = UIApplication.shared.delegate as! AppDelegate
					//appDelegate.sendDeviceTokenToServer(latitude: String(describing: location!.coordinate.latitude), longitude: String(describing: location!.coordinate.longitude), viewController:  UIApplication.shared.delegate?.window??.rootViewController as? ViewController)
				}
			})
		} else {
			setError()
		}
	}
	
	public static func setError() {
		askForNewAddress(message: "Please Enter A Valid Address")
	}
	
	public static func updateDeviceToken() {
		UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]){ (granted, error) in }
		UIApplication.shared.registerForRemoteNotifications()
	}
	
}


