//
//  UserAgreementPt4.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/28/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class UserAgreementPt4: GeneralAskScreen {
	
	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		self.continueArrow.setTitle("Agree", for: UIControlState.normal)
		self.backgroundColor = COLORS.COLOR_5
		super.initDescription(text: "Please report bugs to rbradford.thaumavor.io/contact.html")
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
