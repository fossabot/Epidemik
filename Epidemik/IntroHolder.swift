//
//  IntroHolder.swift
//  Pratically
//
//  Created by Ryan Bradford on 8/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class IntroHolder: UIView {
	
	var introScreens: Array<GeneralAskScreen>!
	
	var descriptionScreen: AppDescription!
	var notificationScreen: NotificationAsk!
	var addressScreen: AddressAsk!
	var userAgreementPt1: UserAgreementPt1!
	var userAgreementPt2: UserAgreementPt2!
		
	var currentID = 0
	
	var done = false
	
	public override init(frame: CGRect) {
		introScreens = Array<GeneralAskScreen>()
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.black
		
		
		createAskObjects()
		addObjectsToScreen()
		
		if(introScreens.count == 0) {
			slideSelfAway(duration: 0)
			return
		}
	}
	
	func createAskObjects() {
		descriptionScreen = AppDescription(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		notificationScreen = NotificationAsk(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		addressScreen = AddressAsk(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		userAgreementPt1 = UserAgreementPt1(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		userAgreementPt2 = UserAgreementPt2(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), holder: self)
		usleep(50000)
	}
	
	func addObjectsToScreen() {
		if notificationScreen.shouldAdd == false {
			return
		}
		if(descriptionScreen.shouldAdd == true) {
			initDescription()
			initUserAgreement()
		}
		if(notificationScreen.shouldAdd == true) {
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
		let vc = UIApplication.shared.delegate?.window??.rootViewController as! ViewController
		vc.initMainScreen()
		UIView.animate(withDuration: duration, animations: {
			self.frame.origin.y -= self.frame.height
		})
	}
	
	func goToNext() {
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
	
}
