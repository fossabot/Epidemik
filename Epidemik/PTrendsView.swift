//
//  PTrendsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/20/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class PTrendsView: UIScrollView {
	
	var dataCenter: DataCenter!
	var blur: UIVisualEffectView!
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.isScrollEnabled = true
		self.alwaysBounceVertical = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func displayTrends() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
		myInitBlur()
		initPullToRefresh()
		initLabel()
		drawGraph()
		tellSicknessPerYear()
		tellAverageTimeSick()
		tellMostCommonTimeSick()
	}
	
	func updateTrends() {
		for view in self.subviews {
			view.removeFromSuperview()
		}
		self.dataCenter.globalTrendData.loadData()
	}
	
	func drawGraph() {
		let y = self.frame.height / 6 + 300
		let rect = CGRect(x: 20, y: y - 5, width: self.frame.width - 45, height: self.frame.height - y - 50)
		let graphBackground = UIView(frame: rect)
		graphBackground.initBlur(blurType: UIBlurEffectStyle.prominent)
		graphBackground.layer.cornerRadius = CGFloat(rect.height/4)
		graphBackground.clipsToBounds = true

		
		let toAdd = SicknessGraph(frame: CGRect(x:0, y:0, width: self.frame.width - 40, height: self.frame.height - y - 50), personData: self.dataCenter.personalTrendData.datapoints)
		graphBackground.addSubview(toAdd)
		self.addSubview(graphBackground)
	}
	
	func tellSicknessPerYear() {
		let text = "You are sick for an average of \n" + String(dataCenter.personalTrendData.getSicknessPerYear()) + " times per year"
		let toDisplay = Trend(toDisplay: text)
		let uiForm = toDisplay.getUIView(width: Double(self.frame.width))
		uiForm.frame.origin.y = self.frame.height / 6
		self.addSubview(uiForm)
	}
	
	func tellAverageTimeSick() {
		let text = "You are sick for an average of \n" + String(dataCenter.personalTrendData.getAverageLengthSickInDays()) + " days at a time"
		let toDisplay = Trend(toDisplay: text)
		let uiForm = toDisplay.getUIView(width: Double(self.frame.width))
		uiForm.frame.origin.y = self.frame.height / 6 + 100
		self.addSubview(uiForm)
	}
	
	func tellMostCommonTimeSick() {
		let toUse = dataCenter.personalTrendData.getAverageDateSick()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM"
		let text = "You usually get sick in " + dateFormatter.string(from: toUse)
		let toDisplay = Trend(toDisplay: text)
		let uiForm = toDisplay.getUIView(width: Double(self.frame.width))
		uiForm.frame.origin.y = self.frame.height / 6 + 200
		self.addSubview(uiForm)
	}
	
	func myInitBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
		blur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		blur.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height*5)
		blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		print("My Blur")
		self.addSubview(blur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
	func initPullToRefresh() {
		refreshControl = UIRefreshControl()
		refreshControl!.addTarget(self, action: #selector(PTrendsView.updateData(_:)), for: UIControlEvents.valueChanged)
		self.addSubview(refreshControl!)
	}
	
	@objc func updateData(_ sender: UIButton?) {
		refreshControl!.endRefreshing()
		dataCenter.loadPersonalTrendData()
	}
	
	func initLabel() {
		let toAdd = UILabel(frame: CGRect(x: 50, y: 10, width: self.frame.width - 100, height: 50))
		toAdd.text = "Personal Trends"
		toAdd.font = PRESETS.FONT_BIG
		toAdd.textAlignment = .center
		self.addSubview(toAdd)
	}
	
}
