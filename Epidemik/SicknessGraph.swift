//
//  SicknessGraph.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class SicknessGraph: UIView {
	
	var personData: Array<Disease>!
	
	init(frame: CGRect, personData: Array<Disease>) {
		self.personData = personData
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func draw(_ rect: CGRect) {
		// Drawing the axis of the graph
		let lineInset = CGFloat(40)
		let axisLine = UIBezierPath()
		axisLine.move(to: CGPoint(x: lineInset, y: lineInset))
		axisLine.addLine(to: CGPoint(x:lineInset, y:self.frame.height - lineInset))
		axisLine.addLine(to: CGPoint(x:self.frame.width - lineInset, y:self.frame.height - lineInset))
		UIColor.black.set()
		axisLine.stroke()
		
		//Drawing the labels on the Y Axis
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
						  NSAttributedStringKey.font            :   UIFont(name: "Futura-CondensedMedium", size: 10),
						  NSAttributedStringKey.foregroundColor : UIColor.black,]
		let sickText = "Sick"
		let sickAttText = NSAttributedString(string: sickText, attributes: attributes)
		let sickRT = CGRect(x: 0, y: lineInset, width: lineInset, height: lineInset)
		sickAttText.draw(in: sickRT)
		
		let healthyText = "Healthy"
		let healthyAttText = NSAttributedString(string: healthyText, attributes: attributes)
		let healthyRT = CGRect(x: 0, y: self.frame.height - lineInset - 10, width: lineInset, height: lineInset)
		healthyAttText.draw(in: healthyRT)
		
		if(self.personData.count == 0) {
			return
		}
		let startDate = personData.first?.date
		let endDate = Date()
		
		//Drawing the labels on the X Axis
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MMM-dd"
		
		let startString = dateFormatter.string(from: startDate!)
		let endString = dateFormatter.string(from: endDate)
		
		let startAttText = NSAttributedString(string: startString, attributes: attributes)
		let startRT = CGRect(x: lineInset, y: self.frame.height - lineInset + 10, width: lineInset, height: lineInset)
		startAttText.draw(in: startRT)
		
		let endAttText = NSAttributedString(string: endString, attributes: attributes)
		let endRT = CGRect(x: self.frame.width - 2*lineInset, y: self.frame.height - lineInset + 10, width: lineInset, height: lineInset)
		endAttText.draw(in: endRT)
		
		//Drawing the sickness line
		let graphWidth = self.frame.width - lineInset*2
		let pixelPerTimeInterval = graphWidth / CGFloat((endDate.timeIntervalSince(startDate!)))
		let dataLine = UIBezierPath()
		let bumpUp = 10 + lineInset
		dataLine.move(to: CGPoint(x: bumpUp, y: self.frame.height - bumpUp))
		for data in self.personData {
			dataLine.addLine(to: CGPoint(x: CGFloat(data.date.timeIntervalSince(startDate!)) * pixelPerTimeInterval + bumpUp, y: self.frame.height - bumpUp))
			dataLine.addLine(to: CGPoint(x: CGFloat(data.date.timeIntervalSince(startDate!)) * pixelPerTimeInterval + bumpUp, y: bumpUp))
			if(data.date_healthy == data.nullData) {
				dataLine.addLine(to: CGPoint(x: CGFloat(endDate.timeIntervalSince(startDate!)) * pixelPerTimeInterval + bumpUp, y: bumpUp))
				dataLine.stroke()
				return
			}
			dataLine.addLine(to: CGPoint(x: CGFloat(data.date_healthy.timeIntervalSince(startDate!)) * pixelPerTimeInterval + bumpUp, y: bumpUp))
			dataLine.addLine(to: CGPoint(x: CGFloat(data.date_healthy.timeIntervalSince(startDate!)) * pixelPerTimeInterval + bumpUp, y: self.frame.height - bumpUp))
		}
		dataLine.addLine(to: CGPoint(x: CGFloat(endDate.timeIntervalSince(startDate!)) * pixelPerTimeInterval + bumpUp, y: self.frame.height - bumpUp))
		dataLine.stroke()
		
	}
	
}
