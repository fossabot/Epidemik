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
	
	var tutorialScreens: Array<GeneralAskScreen>!
	
	var descriptionScreen: AppDescription!
	var notificationScreen: NotificationAsk!
	var addressScreen: AddressAsk!
	var userAgreementPt1: UserAgreementPt1!
	var userAgreementPt2: UserAgreementPt2!
		
	var vc = UIApplication.shared.delegate?.window??.rootViewController as! ViewController
	
	public override init(frame: CGRect) {
		tutorialScreens = Array<GeneralAskScreen>()
		
		super.init(frame: frame)

		createAskObjects()
		addObjectsToScreen()
	}
	
	func createAskObjects() {
		descriptionScreen = AppDescription(frame: self.frame, holder: self)
		let offsetFrame = CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
		notificationScreen = NotificationAsk(frame: offsetFrame, holder: self)
		addressScreen = AddressAsk(frame: offsetFrame, holder: self)
		userAgreementPt1 = UserAgreementPt1(frame: offsetFrame, holder: self)
		userAgreementPt2 = UserAgreementPt2(frame: offsetFrame, holder: self)
	}
	
	func addObjectsToScreen() {
		if  addressScreen.shouldAdd == false {
			return
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
		addTutorialView(view: userAgreementPt1)
		addTutorialView(view: userAgreementPt2)
	}
	
	func initDescription() {
		addTutorialView(view: descriptionScreen)
	}
	
	func initNotifications() {
		addTutorialView(view: notificationScreen)
	}
	
	func initAddress() {
		addTutorialView(view: addressScreen)
	}
	
	func addTutorialView(view: GeneralAskScreen) {
		tutorialScreens.append(view)
		self.addSubview(view)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func askNext() {
		tutorialScreens[0].askForPermission()
	}
	
	//Called when the app has verified the address
	func slideSelfAway(duration: Double) {
		self.vc.initMainScreen()
		UIView.animate(withDuration: duration, animations: {
			self.frame.origin.y -= self.frame.height
		})
	}
	
	func checkLocation() {
		let address = FileRW.readFile(fileName: "address.epi")
		if address == nil {
			self.vc.removeIntroGraphics()
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
				self.addressScreen.shouldAdd = true
				self.addObjectsToScreen()
				self.vc.removeIntroGraphics()
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
					self.vc.showCannotRun()
				} else {
					if(self.tutorialScreens.count == 0) {
						self.vc.initMainScreen()
						self.vc.removeIntroGraphics()
						self.vc.removeWalkthrough()
					} else {
						self.vc.removeIntroGraphics()
					}
				}
				
			}
			
		}
		task.resume()
	}
	
	func goToNext() {
		if(1 == tutorialScreens.count) {
			slideSelfAway(duration: 0.5)
			return
		}
		UIView.animate(withDuration: 0.5, animations: {
			self.tutorialScreens[1].frame = self.tutorialScreens[0].frame
			self.tutorialScreens[0].frame = CGRect(x: -self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
		})
		self.tutorialScreens.remove(at: 0)
	}
	
	
}
