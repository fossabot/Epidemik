//
//  IntroHolder.swift
//  Pratically
//
//  Created by Ryan Bradford on 8/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class TutorialHolder: UIView {
	
	var introScreens: Array<GeneralAskScreen>!
	
	var descriptionScreen: AppDescription!
	var notificationScreen: NotificationAsk!
	var addressScreen: AddressAsk!
	var userAgreementPt1: UserAgreementPt1!
	var userAgreementPt2: UserAgreementPt2!
	
	var currentID = 0
	
	var shouldDisplay = true
	
	var vc = UIApplication.shared.delegate?.window??.rootViewController as! ViewController
	
	public override init(frame: CGRect) {
		introScreens = Array<GeneralAskScreen>()
		super.init(frame: frame)
		
		
		
		createAskObjects()
		addObjectsToScreen()
	}
	
	func createAskObjects() {
		descriptionScreen = AppDescription(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		notificationScreen = NotificationAsk(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		addressScreen = AddressAsk(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		userAgreementPt1 = UserAgreementPt1(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		userAgreementPt2 = UserAgreementPt2(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
	}
	
	func addObjectsToScreen() {
		if  addressScreen.shouldAdd == false && notificationScreen.shouldAdd == false {
			
		}
		if(descriptionScreen.shouldAdd == true) {
			initDescription()
			initUserAgreement()
		}
		if(addressScreen.shouldAdd == true || notificationScreen.shouldAdd == true) {
			initNotifications()
		}
		if(addressScreen.shouldAdd) {
			initAddress()
		}
	}
	
	func initUserAgreement() {
		introScreens.append(userAgreementPt1)
		self.addSubview(userAgreementPt1)
		
		introScreens.append(userAgreementPt2)
		self.addSubview(userAgreementPt2)
	}
	
	func initDescription() {
		introScreens.append(descriptionScreen)
		self.addSubview(descriptionScreen)
	}
	
	func initNotifications() {
		introScreens.append(notificationScreen)
		self.addSubview(notificationScreen)
	}
	
	func initAddress() {
		introScreens.append(addressScreen)
		self.addSubview(addressScreen)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func askNext() {
		introScreens[currentID].askForPermission()
	}
	
	func slideSelfAway(duration: Double) {
		self.vc.initMainScreen()
		UIView.animate(withDuration: duration, animations: {
			self.frame.origin.y -= self.frame.height
		})
	}
	
	func getLocation() {
		let address = FileRW.readFile(fileName: "address.epi")
		if address == nil {
			self.shouldDisplay = true
			self.vc.useIntroHolder()
			return
		}
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
			if(error != nil) {
			} else if let buffer = placemarks?[0] {
				let location = buffer.location;
				self.endEditing(true)
				self.checkActiveRegion(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
			} else {
				self.showCannotRun()
				self.shouldDisplay = true
				self.vc.useIntroHolder()
			}
		})
	}
	
	func checkActiveRegion(latitude: Double, longitude: Double) {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/isActive.php")!)
		request.httpMethod = "POST"
		let postString = "latitude=" + String(latitude) + "&longitude=" + String(longitude)
		request.httpBody = postString.data(using: .utf8)
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
			
			DispatchQueue.main.sync {
				if(responseString == "0") {
					self.showCannotRun()
					self.shouldDisplay = true
					self.vc.useIntroHolder()
				} else {
					if(self.introScreens.count == 0) {
						self.shouldDisplay = false
						self.vc.useIntroHolder()
					} else {
						self.shouldDisplay = true
						self.vc.useIntroHolder()
					}
				}
				
			}
			
		}
		task.resume()
	}
	
	func goToNext() {
		print("Going")
		if(currentID+1 == introScreens.count) {
			slideSelfAway(duration: 0.5)
			return
		}
		UIView.animate(withDuration: 0.5, animations: {
			self.introScreens[self.currentID+1].frame = self.introScreens[self.currentID].frame
			self.introScreens[self.currentID].frame = CGRect(x: -self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
		})
		currentID += 1
	}
	
	func showCannotRun() {
		let cannotRun = CannotRun(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		self.addSubview(cannotRun)
		UIView.animate(withDuration: 0.5, animations: {
			cannotRun.frame.origin.x -= self.frame.width
		})
	}
	
}
