//
//  SettingsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/12/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public class SettingsView: UIView {
	
	var smallButtonWidth: CGFloat!
	var smallButtonHeight: CGFloat!
	var smallButtonGap: CGFloat!
	
	var addressChanger: UIButton!
	var detailSelector: BarSelector!
	var bugReporter: UIButton!
	var logOut: UIButton!

	var mainView: MainHolder!
	
	public init(frame: CGRect, mainView: MainHolder) {
		self.mainView = mainView
		self.mainView.endEditing(true)
		super.init(frame: frame)
		smallButtonWidth = 3*frame.width/5
		smallButtonHeight = self.frame.height/12
		smallButtonGap = self.frame.height/16
		
		//self.backgroundColor = COLORS.COLOR_1
		initBlur()
		initAddressChanger()
		initDone()
		initDetailSelector()
		initBugReporter()
		initLogOut()
	}
	
	func initAddressChanger() {
		addressChanger = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: smallButtonGap, width: smallButtonWidth, height: smallButtonHeight))
		addressChanger.backgroundColor = PRESETS.GRAY
		addressChanger.addTarget(self, action: #selector(SettingsView.changeAddress(_:)), for: .touchUpInside)
		addressChanger.layer.cornerRadius = 20
		addressChanger.titleLabel?.font = PRESETS.FONT_BIG
		addressChanger.setTitle("Change Address", for: .normal)
		self.addSubview(addressChanger)
	}
	
	@objc func changeAddress(_ sender: UIButton?) {
		ADDRESS.askForNewAddress(message: "What is Your New Address?")
	}
	
	func initDetailSelector() {
		detailSelector = DetailSelector(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 2*smallButtonGap+smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight), overlayCreator: mainView.mapView.overlayCreator)
		self.addSubview(detailSelector)
		let textOffset = CGFloat(10)
		createDetailTextBox(x: 0, y: 2*smallButtonGap+smallButtonHeight+textOffset, message: "High Performance")
		createDetailTextBox(x: (self.frame.width+smallButtonWidth)/2, y: 2*smallButtonGap+smallButtonHeight+textOffset, message: "High Detail")
	}
	
	func initBugReporter() {
		bugReporter = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 3*smallButtonGap+2*smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight))
		bugReporter.backgroundColor = PRESETS.GRAY
		bugReporter.addTarget(self, action: #selector(SettingsView.reportBug(_:)), for: .touchUpInside)
		bugReporter.layer.cornerRadius = 20
		bugReporter.titleLabel?.font = PRESETS.FONT_BIG
		bugReporter.setTitle("Report a Bug", for: .normal)
		self.addSubview(bugReporter)
	}
	
	@objc func reportBug(_ sender: UIButton?) {
		UIApplication.shared.open(URL(string: "http://rbradford.thaumavor.io/contact.html")!, options: [:], completionHandler: { (notUsed) in
			self.removeFromSuperview()
		})
	}
	
	func initLogOut() {
		let logOut = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 4*smallButtonGap+3*smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight))
		logOut.backgroundColor = PRESETS.GRAY
		logOut.addTarget(self, action: #selector(SettingsView.logOut(_:)), for: .touchUpInside)
		logOut.layer.cornerRadius = 20
		logOut.titleLabel?.font = PRESETS.FONT_BIG
		logOut.setTitle("Log Out", for: .normal)
		self.addSubview(logOut)
	}
	
	@objc func logOut(_ sender: UIButton?) {
		FileRW.writeFile(fileName: "username.epi", contents: "")
		let vc = UIApplication.shared.keyWindow?.rootViewController as! ViewController!
		vc?.restart()
	}
	
	func createDetailTextBox(x: CGFloat, y: CGFloat, message: String) {
		let toAdd = UITextView(frame: CGRect(x: x, y: y, width: (self.frame.width-smallButtonWidth)/2, height: smallButtonHeight))
		toAdd.text = message
		toAdd.font = PRESETS.FONT_SMALL
		toAdd.isSelectable = false
		toAdd.textColor = UIColor.black
		toAdd.backgroundColor = UIColor.clear
		toAdd.textAlignment = NSTextAlignment.center
		toAdd.isEditable = false
		self.addSubview(toAdd)
	}
	
	func initDone() {
		let y = 4*smallButtonGap+5*smallButtonHeight
		let done = UIButton(frame: CGRect(x: 20, y: y, width: self.frame.width-40, height: self.frame.height - y - smallButtonGap))
		done.backgroundColor = PRESETS.RED
		done.addTarget(self, action: #selector(SettingsView.removeSelf(_:)), for: .touchUpInside)
		done.layer.cornerRadius = 20
		done.titleLabel?.font = PRESETS.FONT_BIG
		done.setTitle("Done", for: .normal)
		self.addSubview(done)
	}
	
	@objc func removeSelf(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.y -= self.frame.height
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
