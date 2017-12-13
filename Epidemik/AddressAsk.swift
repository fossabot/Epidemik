//
//  AddressAsk.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/24/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

public class AddressAsk: GeneralAskScreen {
	
	var FILE_NAME = "address.epi"

	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		super.initDescription(text: "We Need Your Address to Properely Analyze Your Data")
		self.backgroundColor = COLORS.COLOR_5
		self.continueArrow.setTitle("Continue", for: UIControlState.normal)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func setShouldAdd() {
		let currentAddress = FileRW.readFile(fileName: FILE_NAME)
		self.shouldAdd = currentAddress == nil || currentAddress == ""
	}
	
	override func askForPermission() {
		getAddress(message: "What is Your Address?")
	}
	
	func getAddress(message: String) {
		let alert = UIAlertController(title: "Address", message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
			let textf1 = alert.textFields![0] as UITextField
			self.convertToCordinates(address: textf1.text!)
		}))
		alert.addTextField(configurationHandler: {(textField: UITextField) in
			textField.placeholder = "1 Main St. New York, NY"
			textField.isSecureTextEntry = false
		})
		UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
	}
	
	func convertToCordinates(address: String) {
		if (address != "") {
			FileRW.writeFile(fileName: self.FILE_NAME, contents: address)
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
				if(error != nil) {
					self.setError()
				} else if let buffer = placemarks?[0] {
					let location = buffer.location;
					self.endEditing(true)
					let appDelegate = UIApplication.shared.delegate as! AppDelegate
					appDelegate.sendDeviceTokenToServer(latitude: String(describing: location!.coordinate.latitude), longitude: String(describing: location!.coordinate.longitude), transition: self)
				} else {
					self.setError()
				}
			})
		} else {
			setError()
		}
	}
	
	func transitonProperly(result: String) {
		DispatchQueue.main.sync {
			print(result)
			if(result == "0") {
				holder.showCannotRun()
			} else {
				holder.goToNext()
			}
		}
	}
	
	func setError() {
		getAddress(message: "Please Enter A Valid Address")
	}
	
}
