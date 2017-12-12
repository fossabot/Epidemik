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
	
	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		self.continueArrow.removeFromSuperview()
		super.initDescription(text: "Your region is not supported yet. Check back later!")
		self.backgroundColor = UIColor.red
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}


