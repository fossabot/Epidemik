//
//  Trend.swift
//  EpidemikWidget
//
//  Created by Ryan Bradford on 12/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class Trend: UIView {
	
	var name: String!
	var weight: Double!
	public static var nothing = "Nothing Spreading"

	init(name: String, weight: Double, width: Double) {
		self.name = name
		self.weight = weight
		super.init(frame: CGRect(x: 0, y: 0, width: width, height: 30))
		initBlur()
		initLabel()
		initImage()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func toString() -> String {
		return name + "," + String(weight)
	}
	
	func initImage() {
		let cornerImage = getAppropriateDiseaseImage()
		let cornerImageHolder = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
		cornerImageHolder.image = cornerImage
		self.addSubview(cornerImageHolder)
	}
	
	func initBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
		let blurOverlay = UIVisualEffectView(effect: blurEffect)
		blurOverlay.layer.cornerRadius = self.frame.height/2
		blurOverlay.clipsToBounds = true
		//always fill the view
		blurOverlay.frame = CGRect(x: 0, y: 0, width: self.frame.width - 2*self.frame.origin.x, height: self.frame.height)
		blurOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		self.addSubview(blurOverlay) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
	
	func initLabel() {
		let toReturn = UITextView(frame: CGRect(x: self.frame.height, y: 0, width: self.frame.width, height: 30))
		toReturn.text = name + ": " + String(round(10*weight)/10) + "%"
		toReturn.font = PRESETS.FONT_BIG
		toReturn.backgroundColor = UIColor.clear
		toReturn.isEditable = false
		toReturn.isSelectable = false
		self.addSubview(toReturn)
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
