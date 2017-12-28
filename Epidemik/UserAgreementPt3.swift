//
//  UserAgreementPt3.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/28/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class UserAgreementPt3: GeneralAskScreen {
	
	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		self.continueArrow.setTitle("Continue", for: UIControlState.normal)
		super.initDescription(text: "Epidemik is Still in a Beta State in the Greater Boston Area")
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
