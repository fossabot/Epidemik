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
		ADDRESS.askForNewAddress(message: "What is Your New Address?", currentView: self)
	}
	
}
