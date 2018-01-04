//
//  NotificationsAsk.swift
//  Pratically
//
//  Created by Ryan Bradford on 8/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public class NotificationAsk: GeneralAskScreen {
	
	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		self.backgroundColor = COLORS.COLOR_5
		super.initDescription(text: "We Will Notifify You About Coming Diseases")
		self.continueArrow.setTitle("Agree", for: UIControlState.normal)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func askForPermission() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.introHolder = holder
		UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]){ (granted, error) in }
		UIApplication.shared.registerForRemoteNotifications()
		self.holder.goToNext()
	}
	
	override func setShouldAdd() {
		let current = UNUserNotificationCenter.current()
		
		current.getNotificationSettings(completionHandler: { (settings) in
			if settings.authorizationStatus != .notDetermined {
				self.shouldAdd = false
			}
		})
	}
	
}
