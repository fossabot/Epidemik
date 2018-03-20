//
//  DiseaseGraph.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/16/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class DiseaseGraph: UIView {
	
	var dates = Array<Date>()
	var weights = Array<Double>()
	var backButton: UIButton!
	
	init(frame: CGRect, diseaseName: String) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		initBlur()
		loadData(diseaseName: diseaseName)
		addBackButton()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func loadData(diseaseName: String) {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getDiseaseTrendData.php")!)
		request.httpMethod = "POST"
		let username = FileRW.readFile(fileName: "username.epi")!
		let postString = "username=" + username + "&disease_name=" + diseaseName
		request.httpBody = postString.data(using: .utf8)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard let _ = data, error == nil else {
				print("error=\(String(describing: error))")
				return
			}
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				return
			}
			let responseString = String(data: data!, encoding: .utf8)
			self.processResponser(resp: responseString!)
		}
		task.resume()
	}
	
	
	func processResponser(resp: String) {
		let lines = resp.split(separator: "\n")
		for line in lines {
			let parts = line.split(separator: ",")
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			let dateString = String(parts[0])
			let date = dateFormatter.date(from: dateString)
			let weight = Double(parts[1])!
			dates.append(date!)
			weights.append(weight)
		}
		DispatchQueue.main.sync {
			let drawing = DiseaseGraphDrawing(frame: CGRect(x: 0, y: 50, width: self.frame.width, height: 300), dates: dates, weights: weights)
			self.addSubview(drawing)
		}
	}
	
	func addBackButton() {
		backButton = UIButton(frame: CGRect(x: 20, y: self.frame.height - 120, width: self.frame.width - 40, height: 100))
		backButton.setTitle("BACK", for: .normal)
		backButton.backgroundColor = PRESETS.RED
		backButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		backButton.layer.cornerRadius = 15
		self.addSubview(backButton)
	}
	
	@objc func back(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x += self.frame.width
		})
	}
}

class DiseaseGraphDrawing: UIView {
	
	var dates: Array<Date>!
	var weights: Array<Double>!
	
	init(frame: CGRect, dates: Array<Date>, weights: Array<Double>) {
		self.dates = dates
		self.weights = weights
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func draw(_ rect: CGRect) {
		if(dates.count == 0) {
			return
		}
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
						  NSAttributedStringKey.font            :   PRESETS.FONT_SMALL!,
						  NSAttributedStringKey.foregroundColor : UIColor.black,] as [NSAttributedStringKey : Any]
		
		let lineInset = CGFloat(40.0)
		let realWidth = self.frame.width - 2*lineInset
		let realHeight = self.frame.height - 2*lineInset
		
		let titleText = "Percent Sick"
		let titleAttText = NSAttributedString(string: titleText, attributes: attributes)
		let titleRT = CGRect(x: 0, y: 20, width: self.frame.width, height: lineInset)
		titleAttText.draw(in: titleRT)
		
		let sickText = "100%"
		let sickAttText = NSAttributedString(string: sickText, attributes: attributes)
		let sickRT = CGRect(x: 0, y: lineInset, width: lineInset, height: lineInset)
		sickAttText.draw(in: sickRT)
		
		let healthyText = "0%"
		let healthyAttText = NSAttributedString(string: healthyText, attributes: attributes)
		let healthyRT = CGRect(x: 0, y: self.frame.height - lineInset - 10, width: lineInset, height: lineInset)
		healthyAttText.draw(in: healthyRT)
		
		let startDate = dates.first
		let endDate = dates.last
		let totalTime = endDate!.timeIntervalSince(startDate!)
		
		//Drawing the labels on the X Axis
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MMM-dd"
		
		let startString = dateFormatter.string(from: startDate!)
		let endString = dateFormatter.string(from: endDate!)
		
		let startAttText = NSAttributedString(string: startString, attributes: attributes)
		let startRT = CGRect(x: lineInset, y: self.frame.height - lineInset + 10, width: lineInset, height: lineInset)
		startAttText.draw(in: startRT)
		
		let endAttText = NSAttributedString(string: endString, attributes: attributes)
		let endRT = CGRect(x: self.frame.width - 2*lineInset, y: self.frame.height - lineInset + 10, width: lineInset, height: lineInset)
		endAttText.draw(in: endRT)
		
		// Drawing the axis of the graph
		let axisLine = UIBezierPath()
		axisLine.move(to: CGPoint(x: lineInset, y: lineInset))
		axisLine.addLine(to: CGPoint(x: lineInset, y:self.frame.height - lineInset))
		axisLine.addLine(to: CGPoint(x:self.frame.width - lineInset, y:self.frame.height - lineInset))
		UIColor.black.set()
		axisLine.lineWidth =  4
		axisLine.stroke()
		
		let graphLine = UIBezierPath()
		graphLine.lineJoinStyle = .bevel
		
		let firstWeight = weights.first
		let firstY = min(CGFloat(firstWeight!)*realHeight - lineInset, realHeight - lineInset)
		graphLine.move(to: CGPoint(x: lineInset,y: realHeight - firstY))
		for i in 1 ..< dates.count {
			let nextX = lineInset + realWidth * CGFloat(dates[i].timeIntervalSince(startDate!)) / CGFloat(totalTime)
			let nextY = min(CGFloat(weights[i])*realHeight - lineInset, realHeight - lineInset)
			graphLine.addLine(to: CGPoint(x: nextX, y: realHeight - nextY))
		}
		UIColor.black.set()
		graphLine.lineWidth = 2
		graphLine.stroke()
	}
	
}












