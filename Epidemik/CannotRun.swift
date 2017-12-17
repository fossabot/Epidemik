//
//  UserAgreement.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/29/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class CannotRun: GeneralAskScreen {
	
	var smallButtonWidth: CGFloat!
	var smallButtonHeight: CGFloat!
	var smallButtonGap: CGFloat!
	
	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		smallButtonWidth = 3*frame.width/5
		smallButtonHeight = self.frame.height/8
		smallButtonGap = self.frame.height/16
		self.continueArrow.removeFromSuperview()
		super.initDescription(text: "Your region is not supported yet. Check back later!")
		self.backgroundColor = UIColor.red
		initChangeAddress()
	}
	
	public func initChangeAddress() {
		let addressChanger = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: smallButtonGap, width: smallButtonWidth, height: smallButtonHeight))
		addressChanger.backgroundColor = COLORS.COLOR_4
		addressChanger.addTarget(self, action: #selector(SettingsView.changeAddress(_:)), for: .touchUpInside)
		addressChanger.layer.cornerRadius = 20
		addressChanger.titleLabel?.font = UIFont(name: "Helvetica", size: 23)
		addressChanger.setTitle("Change Address", for: .normal)
		self.addSubview(addressChanger)
	}
	
	@objc func changeAddress(_ sender: UIButton?) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.introHolder = holder
		
		ADDRESS.updateDeviceToken()
		ADDRESS.askForNewAddress(message: "What is Your New Address?", currentView: self)
	}
	
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}


