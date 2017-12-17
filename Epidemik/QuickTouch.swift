//
//  QuickTouch.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class QuickTouch {
	
	public static func initHealthyQuickTouch() { //Dispalys Am Healthy
		let healthyItem = UIApplicationShortcutItem(type: "HealthyButton", localizedTitle: "Am Healthy!")
		UIApplication.shared.shortcutItems = [healthyItem]
	}
	
	public static func initSickQuickTouch() { // Displays a few sickness options
		let commonColdItem = UIApplicationShortcutItem(type: "CommonColdButton", localizedTitle: "Common Cold")
		let fluItem = UIApplicationShortcutItem(type: "FluButton", localizedTitle: "Flu")
		let moreItem = UIApplicationShortcutItem(type: "MoreButton", localizedTitle: "Other")

		UIApplication.shared.shortcutItems = [moreItem, fluItem, commonColdItem]
	}
	
}
