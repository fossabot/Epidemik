//
//  TimeSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 11/26/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class TimeSelector: UIButton {
	
	var colorFrame: UIView!
	var map: Map!
	
	init(frame: CGRect, map: Map) {
		self.map = map
		super.init(frame: frame)
		colorFrame = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		colorFrame.backgroundColor = COLORS.COLOR_2
		self.addSubview(colorFrame)
		
		self.backgroundColor = UIColor.white
		self.layer.cornerRadius = 20
		colorFrame.layer.cornerRadius = 20
		
		let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.update_date(sender:)));
		longGestureRecognizer.minimumPressDuration = 0.1
		longGestureRecognizer.allowableMovement = 5
		self.addGestureRecognizer(longGestureRecognizer)
		
	}
	
	@objc func update_date(sender:UIGestureRecognizer) {
		var newWidth = sender.location(in: self).x
		if(newWidth > self.frame.width) {
			newWidth = self.frame.width
		} else if(newWidth < 0) {
			newWidth = 0
		}
		colorFrame.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.frame.height)
		
		let ratio = newWidth / self.frame.width
		map.filterDate(ratio: Double(ratio))
	}
	
	func updateBar(ratio: Double) {
		colorFrame.frame = CGRect(x: 0, y: 0, width: CGFloat(ratio)*self.frame.width, height: self.frame.height)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
