//
//  AppDescription.swift
//  Pratically
//
//  Created by Ryan Bradford on 8/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class AppDescription: GeneralAskScreen {
	
	override public init(frame: CGRect, holder: TutorialHolder) {
		super.init(frame: frame, holder: holder)
		self.continueArrow.setTitle("Continue", for: UIControlState.normal)
		self.backgroundColor = COLORS.COLOR_5
		super.initDescription(text: "Epidemik is a Crowd Sourced Disease Data Collector")
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
