//
//  UserAgreementPt2.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/22/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//


import Foundation
import UIKit

public class UserAgreementPt2: GeneralAskScreen {
	
	override public init(frame: CGRect, holder: IntroHolder) {
		super.init(frame: frame, holder: holder)
		self.continueArrow.setTitle("Agree", for: UIControlState.normal)
		super.initDescription(text: "Your Data Will Be Used Solely for Research Purposes")
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

