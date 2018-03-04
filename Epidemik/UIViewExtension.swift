//
//  UIViewExtension.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/4/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func initBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
		let blur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		blur.frame = self.bounds
		blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		self.addSubview(blur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
}
