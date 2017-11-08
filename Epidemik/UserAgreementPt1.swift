//
//  UserAgreement.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/29/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class UserAgreementPt1: GeneralAskScreen {
	
	override public init(frame: CGRect, holder: IntroHolder) {
		super.init(frame: frame, holder: holder)
		self.continueArrow.setTitle("Agree", for: UIControlState.normal)
		super.initDescription(text: "Your Data Will Be Used Stored Anonymously and Encrypted")
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

