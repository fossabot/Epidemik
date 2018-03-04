//
//  PasswordAsk.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/23/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

public class PasswordAsk: GeneralAskScreen {
	
	var FILE_NAME = "password.epi"
	
	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		super.initDescription(text: "We Need A Password to Store Your Encrypted Data")
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
		Asker.ask(title: "Password", placeHolder: "password", message: "What Do You Want Your Password to be?", isSecure: true, resp: PasswordResponse())
		holder.goToNext()
	}
	
}

class PasswordResponse: IFunc<String, Int> {
	
	var FILE_NAME = "password.epi"
	
	override func apply(t: String) -> Int? {
		FileRW.writeFile(fileName: FILE_NAME, contents: t)
		return 1
	}
	
}
