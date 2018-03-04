//
//  UsernameAsk.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/23/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

public class UsernameAsk: GeneralAskScreen {
	
	var FILE_NAME = "username.epi"
	
	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		super.initDescription(text: "We Need A Username To Report Individual Statistics for You")
		self.continueArrow.setTitle("Continue", for: UIControlState.normal)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func setShouldAdd() {
		let currentUsername = FileRW.readFile(fileName: FILE_NAME)
		self.shouldAdd = currentUsername == nil || currentUsername == ""
	}
	
	override func askForPermission() {
		Asker.ask(title: "Username", placeHolder: "username", message: "What Do You Want Your Username to be?", isSecure: false, resp: UsernameResponse())
		holder.goToNext()
	}
	
}

class UsernameResponse: IFunc<String, Int> {
	
	var FILE_NAME = "username.epi"
	
	override func apply(t: String) -> Int? {
		FileRW.writeFile(fileName: FILE_NAME, contents: t)
		return 1
	}
	
}
