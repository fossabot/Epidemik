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
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
		initBlur()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func displayTrends() {
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
		let rect = CGRect(x: 20, y: y, width: self.frame.width - 40, height: self.frame.height - y - 50)
		let toAdd = SicknessGraph(frame: rect, personData: self.dataCenter.personalTrendData.datapoints)
		self.addSubview(toAdd)
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
	
}
