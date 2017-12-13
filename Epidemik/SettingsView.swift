//
//  SettingsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/12/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class SettingsView: UIView {
	
	var smallButtonWidth: CGFloat!
	var smallButtonHeight: CGFloat!
	var smallButtonGap: CGFloat!
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		smallButtonWidth = 3*frame.width/5
		smallButtonHeight = self.frame.height/8
		smallButtonGap = self.frame.height/16
		
		self.backgroundColor = COLORS.COLOR_1
		initAddressChanger()
		initDone()
	}
	
	func initAddressChanger() {
		let change = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: smallButtonGap, width: smallButtonWidth, height: smallButtonHeight))
		change.backgroundColor = COLORS.COLOR_4
		change.addTarget(self, action: #selector(SettingsView.changeAddress(_:)), for: .touchUpInside)
		change.layer.cornerRadius = 20
		change.titleLabel?.font = UIFont(name: "Helvetica", size: 23)
		change.setTitle("Change Address", for: .normal)
		self.addSubview(change)
	}
	
	@objc func changeAddress(_ sender: UIButton?) {
		
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
