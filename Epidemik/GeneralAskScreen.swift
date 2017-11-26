//
//  GeneralAskScreen.swift
//  Pratically
//
//  Created by Ryan Bradford on 8/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class GeneralAskScreen: UIView {

	var holder: IntroHolder!
	var shouldAdd: Bool = true
	
	var continueArrow: ContinueArrow!

	var descriptionText: UITextView!
	
	public init(frame: CGRect, holder: IntroHolder) {
		self.holder = holder
		super.init(frame: frame)
		setShouldAdd()
		self.backgroundColor = COLORS.COLOR_4
		continueArrow = ContinueArrow(frame: CGRect(x: 30, y: 30, width: self.frame.width-60, height: self.frame.height/4), holder: holder)
		self.addSubview(continueArrow)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func draw(_ rect: CGRect) {
		var path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: self.frame.height-100))
		path.addLine(to: CGPoint(x: 100, y: self.frame.height))
		path.addLine(to: CGPoint(x: 0, y: self.frame.height))
		path.close()
		COLORS.COLOR_2.set()
		path.stroke()
		path.fill()
		
		path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: self.frame.height-50))
		path.addLine(to: CGPoint(x: 50, y: self.frame.height))
		path.addLine(to: CGPoint(x: 0, y: self.frame.height))
		path.close()
		COLORS.COLOR_1.set()
		
		path.stroke()
		path.fill()
		
		path = UIBezierPath()
		path.move(to: CGPoint(x: self.frame.width, y: self.frame.height-100))
		path.addLine(to: CGPoint(x: self.frame.width - 100, y: self.frame.height))
		path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
		path.close()
		COLORS.COLOR_2.set()
		path.stroke()
		path.fill()
		
		path = UIBezierPath()
		path.move(to: CGPoint(x: self.frame.width, y: self.frame.height-50))
		path.addLine(to: CGPoint(x: self.frame.width - 50, y: self.frame.height))
		path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
		path.close()
		COLORS.COLOR_1.set()
		
		path.stroke()
		path.fill()
	}
	
	func askForPermission() {
		holder.goToNext()
	}
	
	func setShouldAdd() {
		shouldAdd = true
	}
	
	// Draws text centered in the screen of size 50, font Helvetica-Bold
	// String -> Image
	func initDescription(text: String) {
		descriptionText = UITextView(frame: CGRect(x: 30, y: self.frame.height/2-15, width: self.frame.width - 60, height: 3*self.frame.height/4))
		descriptionText.font = UIFont(name: "Helvetica", size: 30)
		descriptionText.backgroundColor = UIColor.clear
		descriptionText.textAlignment = NSTextAlignment.center
		descriptionText.isEditable = false
		descriptionText.isSelectable = false
		descriptionText.text = text
		self.addSubview(descriptionText)
	}
	
}
