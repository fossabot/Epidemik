//
//  TrendsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 11/8/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class GTrendsView: UIScrollView {
	
	var dataCenter: DataCenter!
	var blur: UIVisualEffectView!
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.isScrollEnabled = true
		self.alwaysBounceVertical = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
		myInitBlur()
		initPullToRefresh()
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
	
	func initPullToRefresh() {
		refreshControl = UIRefreshControl()
		refreshControl!.addTarget(self, action: #selector(GTrendsView.updateData(_:)), for: UIControlEvents.valueChanged)
		self.addSubview(refreshControl!)
	}
	
	@objc func updateData(_ sender: UIButton?) {
		refreshControl!.endRefreshing()
	}
	
	func myInitBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
		blur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		blur.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height*5)
		blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		self.addSubview(blur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
}
