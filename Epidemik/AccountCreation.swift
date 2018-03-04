//
//  AccountCreation.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/3/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class LoginScreen: UIView {

	var FILE_NAME = "username.epi"
	
	var usernameTextBox: UITextView!
	
	var shouldAdd: Bool = true
	
	var vc = UIApplication.shared.delegate?.window??.rootViewController as! ViewController
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func askForPermission() {
		if(isLoginCorrect(username: "a", password: "b")) {
			FileRW.writeFile(fileName: FILE_NAME, contents: "username")
			slideSelfAway(duration: 0.5)
		} else {
			warnUser()
		}
		
	}
	
	// Tells the Holder if this view should be added
	func setShouldAdd() {
		let currentUsername = FileRW.readFile(fileName: FILE_NAME)
		self.shouldAdd = currentUsername == nil || currentUsername == ""
	}
	
	//Checks if the database contains a entry of username, password
	func isLoginCorrect(username: String, password: String) -> Bool {
		return true
	}
	
	//Tells the user that their login was incorrect
	func warnUser() {
		
	}
	
	//Moves on the UITextFields for account creation
	// - Address
	// - Password Verification
	// - Adds a Notification ask to the Holder
	func createNewAccount() {
		
	}
	
	//Called when the app has verified the address
	func slideSelfAway(duration: Double) {
		self.vc.initMainScreen()
		UIView.animate(withDuration: duration, animations: {
			self.frame.origin.y -= self.frame.height
		})
	}
	
}
