//
//  TimeSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 11/26/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class TimeSelector: BarSelector {
	
	var map: Map!
	
	init(frame: CGRect, map: Map) {
		self.map = map
		super.init(frame: frame)
	}
	
	@objc override func update(sender:UIGestureRecognizer) -> CGFloat {
		let ratio = super.update(sender: sender)
		map.filterDate(ratio: Double(ratio))
		return ratio
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
