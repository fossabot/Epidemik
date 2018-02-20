//
//  CreateUsername.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/7/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

public class UsernameAsk: GeneralAskScreen {
	
	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		super.initDescription(text: "We Need Your Address to Properely Analyze Your Data")
		self.continueArrow.setTitle("Continue", for: UIControlState.normal)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func setShouldAdd() {
		self.shouldAdd = true
	}
	
	override func askForPermission() {
		//ask for address
	}
	
}

