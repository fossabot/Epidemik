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
import CoreLocation

public class SettingsView: UIView {
	
	var smallButtonWidth: CGFloat!
	var smallButtonHeight: CGFloat!
	var smallButtonGap: CGFloat!
	
	var addressChanger: UIButton!
	var detailSelector: BarSelector!
	
	var mainView: MainHolder!
	
	public init(frame: CGRect, mainView: MainHolder) {
		self.mainView = mainView
		super.init(frame: frame)
		smallButtonWidth = 3*frame.width/5
		smallButtonHeight = self.frame.height/8
		smallButtonGap = self.frame.height/16
		
		self.backgroundColor = COLORS.COLOR_1
		initAddressChanger()
		initDone()
		initDetailSelector()
	}
	
	func initAddressChanger() {
		addressChanger = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: smallButtonGap, width: smallButtonWidth, height: smallButtonHeight))
		addressChanger.backgroundColor = COLORS.COLOR_4
		addressChanger.addTarget(self, action: #selector(SettingsView.changeAddress(_:)), for: .touchUpInside)
		addressChanger.layer.cornerRadius = 20
		addressChanger.titleLabel?.font = UIFont(name: "Helvetica", size: 23)
		addressChanger.setTitle("Change Address", for: .normal)
		self.addSubview(addressChanger)
	}
	
	@objc func changeAddress(_ sender: UIButton?) {
		ADDRESS.updateDeviceToken()
		ADDRESS.askForNewAddress(message: "What is Your New Address?", currentView: self)
	}
	
	func initDetailSelector() {
		detailSelector = DetailSelector(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 2*smallButtonGap+smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight), overlayCreator: mainView.mapView.overlayCreator)
		self.addSubview(detailSelector)
		
		
		let textOffset = CGFloat(10)
		
		createDetailTextBox(x: 0, y: 2*smallButtonGap+smallButtonHeight+textOffset, message: "High Preformance")
		
		createDetailTextBox(x: (self.frame.width+smallButtonWidth)/2, y: 2*smallButtonGap+smallButtonHeight+textOffset, message: "High Detail")
	}
	
	func createDetailTextBox(x: CGFloat, y: CGFloat, message: String) {
		let toAdd = UITextView(frame: CGRect(x: x, y: y, width: (self.frame.width-smallButtonWidth)/2, height: smallButtonHeight))
		toAdd.text = message
		toAdd.font = UIFont(name: "Helvetica", size: 9)
		toAdd.isSelectable = false
		toAdd.textColor = UIColor.white
		toAdd.backgroundColor = UIColor.clear
		toAdd.textAlignment = NSTextAlignment.center
		toAdd.isEditable = false
		self.addSubview(toAdd)
	}
	
	func initDone() {
		let done = UIButton(frame: CGRect(x: 20, y: 3*self.frame.height/4, width: self.frame.width-40, height: self.frame.height/5))
		done.backgroundColor = COLORS.COLOR_3
		done.addTarget(self, action: #selector(SettingsView.removeSelf(_:)), for: .touchUpInside)
		done.layer.cornerRadius = 20
		done.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 30)
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
