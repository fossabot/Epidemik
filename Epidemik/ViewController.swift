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
	
	var accCreation: LoginScreen!
	
	var mainView: MainHolder!
	
	var introGraphic: UIView!
	
	var shouldDisplaySicknessSelector = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.displayIntroGraphics() //Display the intro graphic again
		//Maybe have it do something fancy?
		self.initWalkthrough()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	//Displays the Graphic before everything is loaded
	func displayIntroGraphics() {
		introGraphic = UIView(frame: self.view.frame)
		introGraphic.backgroundColor = UIColor.white
		self.view.addSubview(introGraphic)
		usleep(500000)
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
		mainView = MainHolder(frame: self.view.frame)
		self.view.addSubview(mainView)
		self.view.sendSubview(toBack: mainView)
		if shouldDisplaySicknessSelector == true {
			self.displayDiseaseSelector()
		}
	}
	
	// Creates the view that holds all the intro screens
	func initWalkthrough() {
		accCreation = LoginScreen(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)) //Calls initDatabase when done
		if(accCreation.shouldAdd) {
			self.view.addSubview(accCreation)
			self.view.sendSubview(toBack: accCreation)
		} else {
			initMainScreen()
		}
		self.removeIntroGraphics()
	}
	
	// Removes the graphic that is there before things load
	func removeIntroGraphics() {
		UIView.animate(withDuration: 0.5, animations: {
			self.introGraphic.frame.origin.x -= self.view.frame.width
		}, completion: {
			(value: Bool) in
			self.introGraphic.removeFromSuperview()
		})
	}
	
	// Removes the graphics that lead the user through account creation
	func removeWalkthrough() {
		UIView.animate(withDuration: 0.5, animations: {
			self.accCreation.frame.origin.x -= self.view.frame.width
		}, completion: {
			(value: Bool) in
			self.accCreation.removeFromSuperview()
		})
	}
	
	// Shows the map and all its parts
	func showMainView() {
		if (mainView == nil) {
			initMainScreen()
		}
		if mainView.isSettings {
			self.mainView.settings.removeSelf(nil)
		}
		self.mainView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
		self.view.bringSubview(toFront: self.mainView)
		UIView.animate(withDuration: 0.5, animations: {
			self.mainView.frame.origin.x -= self.view.frame.width
		})
		
	}
	
	// Displays the sickness selection screen in an updated state
	func refreshSicknessScreen() {
		if mainView != nil {
			mainView.refreshSicknessScreen()
		}
	}
	
	// Displays the screen where the user can sleect what sickness they have
	func displayDiseaseSelector() {
		if mainView != nil {
			mainView.displayDiseaseSelector()
			shouldDisplaySicknessSelector = false
		} else {
			shouldDisplaySicknessSelector = true
		}
	}
	
	// Updates the trends based on any changes or a users new location
	func updateTrends() {
		if mainView != nil && mainView.trendsView
			!= nil {
			mainView.trendsView.updateTrends()
		}
	}
	
}

