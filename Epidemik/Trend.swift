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
	
	var name: String!
	var weight: Double!
	public static var nothing = "Nothing Spreading"
	
	var height = 60.0
	var xInset = 20.0
	
	init(name: String, weight: Double) {
		self.name = name
		self.weight = weight
	}

	func toString() -> String {
		return name + "," + String(weight)
	}
	
	func getUIView(width: Double) -> UIView {
		let toAdd = UIView(frame: CGRect(x: self.xInset, y: 0, width: width, height: self.height))
		toAdd.addSubview(initBlur(width: width))
		toAdd.addSubview(initImage())
		toAdd.addSubview(initLabel(width: width))
		return toAdd
	}
	
	func initImage() -> UIView {
		let cornerImage = getAppropriateDiseaseImage()
		let cornerImageHolder = UIImageView(frame: CGRect(x: 0, y: 0, width: self.height, height: self.height))
		cornerImageHolder.image = cornerImage
		return cornerImageHolder
	}
	
	func initBlur(width: Double) -> UIView {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
		let blurOverlay = UIVisualEffectView(effect: blurEffect)
		blurOverlay.layer.cornerRadius = CGFloat(self.height/2)
		blurOverlay.clipsToBounds = true
		//always fill the view
		blurOverlay.frame = CGRect(x: 0, y: 0, width: width - 2*self.xInset, height: self.height)
		blurOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		return blurOverlay //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
	func initLabel(width: Double) -> UIView {
		let toReturn = UITextView(frame: CGRect(x: self.height, y: 0, width: width, height: 100))
		toReturn.text = "Name: " + name + "\n  Infection Chance: " + String(round(10*weight)/10) + "%"
		if width > 350 {
			toReturn.font = UIFont(name: "Helvetica", size: 20)
		} else {
			toReturn.font = UIFont(name: "Helvetica", size: 15)
		}
		
		toReturn.backgroundColor = UIColor.clear
		toReturn.isEditable = false
		toReturn.isSelectable = false
		return toReturn
	}
	
	func getAppropriateDiseaseImage() -> UIImage {
		var properName = ""
		let randomID = Int(arc4random_uniform(5))
		switch randomID {
			case 0 : properName="sickness2.png"
			case 1 : properName="sickness3.png"
			case 2 : properName="sickness4.png"
			case 3 : properName="sickness5.png"
			default: properName="sickness6.png"
		}
		if name == Trend.nothing {
			properName = "smiley.png"
		}
		return UIImage(named: properName)!
		
	}
	
}
