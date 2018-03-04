//
//  PTrendsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/20/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class PTrendsView: UIScrollView {
	
	var dataCenter: DataCenter!
	var blur: UIVisualEffectView!
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.isScrollEnabled = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
		initBlur()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func displayTrends() {
		let trends = dataCenter.getTrendData()
		let startShift = self.frame.height / 6
		var lastY = CGFloat(0.0)
		for i in 0 ..< trends.count {
			let toDisplay = trends[i].getUIView(width: Double(self.frame.width))
			toDisplay.frame.origin.y = CGFloat(i) * (6.0/5.0*toDisplay.frame.height) + startShift
			self.addSubview(toDisplay)
			lastY = CGFloat(i) * (6.0/5.0*toDisplay.frame.height)
			lastY += startShift + 2*toDisplay.frame.height
		}
		if(trends.count > 0) {
			self.contentSize = CGSize(width: self.frame.width, height: lastY)
		}
	}
	
	func updateTrends() {
		for view in self.subviews {
			view.removeFromSuperview()
		}
		self.dataCenter.trendPoint.loadData()
	}
	
}
