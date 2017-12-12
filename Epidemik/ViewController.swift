//
//  ViewController.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/15/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import UIKit
import MapKit

//Crowd Sourced Disease

//App Parts
	//Map
		//Can be displayed versus time
	//Notifications for disease
		//When a disease is spreading in an area
	//Disease Reporting
		//Allows the user to say when they are sick
		//Allows the user to report when they are better
		//Say what type of sickness they have?
	//Startup Screen
		//User reports where they live

class ViewController: UIViewController {

	var introView: IntroHolder!
	
	var introGraphic: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.displayIntroGraphics()
		self.initHolder()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	func displayIntroGraphics() {
		introGraphic = UIView(frame: self.view.frame)
		introGraphic.backgroundColor = UIColor.blue
		self.view.addSubview(introGraphic)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// Creates the main screen that handles the three seperate views
	// - Left: Map
	// - Middle: Sickness Screen
	// - Right: Trends
	func initMainScreen() {
		let view = MainHolder(frame: self.view.frame)
		self.view.addSubview(view)
		self.view.sendSubview(toBack: view)
	}
	
	// Creates the view that holds all the intro screens
	func initHolder() {
		introView = IntroHolder(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)) //Calls initDatabase when done
		self.view.addSubview(introView)
		self.view.sendSubview(toBack: introView)
		introView.getLocation()
	}
	
	func useIntroHolder() {
		if introView.shouldDisplay {
			UIView.animate(withDuration: 0.5, animations: {
				self.introGraphic.frame.origin.x -= self.view.frame.width
			}, completion: {
				(value: Bool) in
				self.introGraphic.removeFromSuperview()
			})
		} else {
			self.initMainScreen()
			usleep(500000)
			UIView.animate(withDuration: 0.5, animations: {
				self.introGraphic.frame.origin.x -= self.view.frame.width
				self.introView.frame.origin.x -= self.view.frame.width
			}, completion: {
				(value: Bool) in
				self.introView.removeFromSuperview()
				self.introGraphic.removeFromSuperview()
			})
		}
	}


}

