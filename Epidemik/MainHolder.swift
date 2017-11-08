//
//  MainHolder.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/12/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class MainHolder: UIView {
	
	var mapView: Map!
	var sicknessScreen: SicknessScreen!
	var mapBlur: UIVisualEffectView!
	
	var mapButton: UIButton!
	var sickButton: UIButton!
	var trendsButton: UIButton!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initMap()
		initMapBlur()
		initSickness()
		initChangeButtons()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initSickness() {
		sicknessScreen = SicknessScreen(frame: self.frame)
		self.addSubview(sicknessScreen)
		self.sicknessScreen.alpha = 1
	}
	
	func initMap() {
		let leftFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
		mapView = Map(frame: leftFrame, realLatWidth: 5000, realLongWidth: 5000, startLong: -71.0628642, startLat: 42.4706918)
		self.addSubview(mapView)
	}
	
	func initMapBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
		mapBlur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		mapBlur.frame = mapView.bounds
		mapBlur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		mapView.addSubview(mapBlur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
	@objc func transisitionToMap(_ sender: UIButton?) {
		print("Pressed")
		if(sicknessScreen.frame.origin.x == 0) {
			UIView.animate(withDuration: 0.5, animations: {
				//self.mapBlur.frame.origin.x += self.frame.width
				self.mapBlur.alpha = 0
				self.mapButton.alpha = 1
				
				self.sicknessScreen.frame.origin.x += self.frame.width
				self.sickButton.alpha = 0.5
			})
		}
	}
	
	@objc func transisitionToSick(_ sender: UIButton?) {
		print("Pressed")
		if(sicknessScreen.frame.origin.x != 0) {
			UIView.animate(withDuration: 0.5, animations: {
				//self.mapBlur.frame.origin.x -= self.frame.width
				self.mapBlur.alpha = 1
				self.mapButton.alpha = 0.5
				
				self.sicknessScreen.frame.origin.x -= self.frame.width
				self.sickButton.alpha = 1
			})
		}
	}
	
	@objc func transisitionToTrends(_ sender: UIButton?) {
		print("Pressed")
		if(sicknessScreen.frame.origin.x != 0) {
			UIView.animate(withDuration: 0.5, animations: {
				//self.mapBlur.frame.origin.x -= self.frame.width
				self.mapBlur.alpha = 1
				self.mapButton.alpha = 0.5
				
				self.sicknessScreen.frame.origin.x -= self.frame.width
				self.sickButton.alpha = 1
			})
		}
	}
	
	func initChangeButtons() {
		initMapButton()
		initSickButton()
		initTrendsButton()
	}
	
	func initTrendsButton() {
		let trendsImage = UIImage(named: "trends.png")
		trendsButton = UIButton(frame: CGRect(x: self.frame.width - 55, y: self.frame.height - 55, width: 50, height: 50))
		//changeButton.setTitle("Change Views", for: UIControlState.normal)
		trendsButton.backgroundColor = UIColor.clear
		//changeButton.backgroundColor = UIColor(displayP3Red: 58.0/255.0, green: 64.0/255.0, blue: 0, alpha: 1)
		trendsButton.addTarget(self, action: #selector(MainHolder.transisitionToTrends(_:)), for: .touchUpInside)
		trendsButton.setImage(trendsImage, for: .normal)
		trendsButton.alpha = 1
		self.addSubview(trendsButton)
	}
	
	func initSickButton() {
		let sickImage = UIImage(named: "sickness.png")
		sickButton = UIButton(frame: CGRect(x: self.frame.width/2 - 25, y: self.frame.height - 55, width: 50, height: 50))
		//changeButton.setTitle("Change Views", for: UIControlState.normal)
		sickButton.backgroundColor = UIColor.clear
		//changeButton.backgroundColor = UIColor(displayP3Red: 58.0/255.0, green: 64.0/255.0, blue: 0, alpha: 1)
		sickButton.addTarget(self, action: #selector(MainHolder.transisitionToSick(_:)), for: .touchUpInside)
		sickButton.setImage(sickImage, for: .normal)
		sickButton.alpha = 1
		self.addSubview(sickButton)
	}
	
	func initMapButton() {
		let mapImage = UIImage(named: "globe2")
		mapButton = UIButton(frame: CGRect(x: 5, y: self.frame.height - 55, width: 50, height: 50))
		//changeButton.setTitle("Change Views", for: UIControlState.normal)
		mapButton.backgroundColor = UIColor.clear
		//changeButton.backgroundColor = UIColor(displayP3Red: 58.0/255.0, green: 64.0/255.0, blue: 0, alpha: 1)
		mapButton.addTarget(self, action: #selector(MainHolder.transisitionToMap(_:)), for: .touchUpInside)
		mapButton.setImage(mapImage, for: .normal)
		mapButton.alpha = 0.5
		self.addSubview(mapButton)
	}
	
}

