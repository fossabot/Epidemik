//
//  DetailSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/13/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//


import Foundation
import UIKit

public class DetailSelector: BarSelector {
	
	var overlayCreator: MapOverlayCreator!
	
	let base = 20.0
	let totalVariability = 30.0
	
	init(frame: CGRect, overlayCreator: MapOverlayCreator) {
		self.overlayCreator = overlayCreator
		super.init(frame: frame)
		colorFrame.frame = CGRect(x: colorFrame.frame.origin.x, y: colorFrame.frame.origin.y, width: colorFrame.frame.width*getRatio(), height: colorFrame.frame.height)
	}
	
	@objc override func update(sender:UIGestureRecognizer) -> CGFloat {
		let ratio = super.update(sender: sender)
		//overlayCreator.numXY = Double(CGFloat(base)+CGFloat(totalVariability)*ratio)
		return ratio
	}
	
	func getRatio() -> CGFloat {
		return 1
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
