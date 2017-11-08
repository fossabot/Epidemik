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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.initHolder()
		// Do any additional setup after loading the view, typically from a nib.
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
	}
	
	// Creates the view that holds all the intro screens
	func initHolder() {
		introView = IntroHolder(frame: self.view.frame) //Calls initDatabase when done
		self.view.addSubview(introView)
	}


}

