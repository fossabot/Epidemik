//
//  TransitionControls.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/28/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

open class TransitionControls: NSObject {
	
	var swipeLeft: UISwipeGestureRecognizer?
	var swipeRight: UISwipeGestureRecognizer?
	var motionManager : CMMotionManager?
	var mainView: MainHolder
	
	init(mainView: MainHolder) {
		self.mainView = mainView
		super.init()
		self.initSwipeControl()
	}

	func initSwipeControl() {
		swipeLeft = UISwipeGestureRecognizer()
		swipeLeft!.addTarget(self, action: #selector(TransitionControls.transitionRight))
		swipeLeft!.direction = .left
		
		swipeRight = UISwipeGestureRecognizer()
		swipeRight!.addTarget(self, action: #selector(TransitionControls.transitionLeft))
		swipeRight!.direction = .right
		mainView.addGestureRecognizer(swipeLeft!)
		mainView.addGestureRecognizer(swipeRight!)
		mainView.isUserInteractionEnabled = true
	}
	
	@objc func transitionLeft(sender: UIGestureRecognizer!) {
		if mainView.trendsView.frame.origin.x == 0.0 {
			mainView.transisitionToSick(nil)
		} else if mainView.sicknessView.frame.origin.x == 0.0 {
			mainView.transisitionToMap(nil)
		}
	}
	
	@objc func transitionRight(sender: UIGestureRecognizer!) {
		if mainView.sicknessView.frame.origin.x == 0.0 {
			mainView.transisitionToTrends(nil)
		}
	}

}

