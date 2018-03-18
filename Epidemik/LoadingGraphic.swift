//
//  LoadingGraphic.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/18/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class LoadingGraphic: UIView {
	
	var mainImage: UIImageView!
	var animateImage: UIImageView!
	
	var shouldContinue = true
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initMainImage()
		initAnimateImage()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initMainImage() {
		let toAdd = UIImage(named: "epidemik.png")
		self.mainImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		self.mainImage.image = toAdd!
		self.addSubview(self.mainImage)
		
	}
	
	func initAnimateImage() {
		let toAdd = UIImage(named: "loading.png")
		self.animateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		self.animateImage.image = toAdd!
		self.addSubview(self.animateImage)
	}
	
	func startAnimation() {
		UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
			self.animateImage.transform = self.animateImage.transform.rotated(by: .pi)
		}) { finished in
			if(self.shouldContinue) {
				self.startAnimation()
			} else {
				UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
					self.frame.origin.x -= 500
				})
			}
		}
	}
	
	func stopAnimation() {
		self.shouldContinue = false
	}
	
}
