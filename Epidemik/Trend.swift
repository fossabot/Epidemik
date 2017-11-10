//
//  Trend.swift
//  Epidemik
//
//  Created by Ryan Bradford on 11/9/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class Trend {
	
	var name: String
	var weight: Double
	
	init(name: String, weight: Double) {
		self.name = name
		self.weight = weight
	}
	
	func toString() -> String {
		return name + "," + String(weight)
	}
	
	func toUILabel(width: Double) -> UITextView {
		let toReturn = UITextView(frame: CGRect(x: 20, y: 0, width: width, height: 100))
		toReturn.text = "Name: " + name + "\n  Growth: " + String(weight)
		toReturn.font = UIFont(name: "Helvetica-Bold", size: 20)
		toReturn.backgroundColor = UIColor.clear
		return toReturn
	}
	
}
