//
//  AccCreationTextBox.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/14/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class AccCreationTextBox: UITextField {
	
	var toDisplay: UIImage!
	
	init(frame: CGRect, toDisplay: UIImage) {
		self.toDisplay = toDisplay
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		self.autocorrectionType = .no
		self.autocapitalizationType = .none
		self.text = text
		self.textAlignment = .center
		self.clearsOnBeginEditing = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		let xOffset = self.frame.width / 12
		
		let underline = UIBezierPath()
		UIColor.black.set()
		let bumpUp = self.frame.height - 5.0
		underline.move(to: CGPoint(x: 0, y: bumpUp))
		underline.addLine(to: CGPoint(x: self.frame.width, y: bumpUp))
		underline.lineWidth = 2
		underline.stroke()
		
		let imageHeight = 3*self.frame.height / 4
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageHeight, height: imageHeight))
		imageView.image = toDisplay
		self.addSubview(imageView)
	}
	
}
