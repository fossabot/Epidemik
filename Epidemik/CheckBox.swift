//
//  CheckBox.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/24/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class CheckBox: UIButton {
	// Images
	let checkedImage = UIImage(named: "checked")! as UIImage
	let uncheckedImage = UIImage(named: "unchecked")! as UIImage
	
	// Bool property
	var isChecked: Bool = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
		self.isChecked = false
		self.setImage(uncheckedImage, for: UIControlState.normal)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@objc func buttonClicked(sender: UIButton) {
		if sender == self {
			isChecked = !isChecked
		}
		if(isChecked) {
			self.setImage(checkedImage, for: UIControlState.normal)
		} else {
			self.setImage(uncheckedImage, for: UIControlState.normal)
		}
	}
}
