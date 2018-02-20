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
	var sicknessView: SicknessScreen!
	var trendsView: TrendsView!
	var mapBlur: UIVisualEffectView!
	
	var mapButton: UIButton!
	var sickButton: UIButton!
	var trendsButton: UIButton!
	
	var settingsButton: UIButton!
	
	var settings: SettingsView!
	var isSettings = false
	
	var transControls: TransitionControls!
	
	var dataCenter: DataCenter!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initMap()
		initMapBlur()
		initSickness()
		initTrends()
		initChangeButtons()
		initSettings()
		initTransition()
		self.dataCenter = DataCenter(diseaseReactor: DiseaseLoadingReactor(map: self.mapView), trendReactor: TrendLoadingReactor(trendsView: self.trendsView))
		self.mapView.dataCenter = self.dataCenter
		self.trendsView.dataCenter = self.dataCenter

	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initSickness() {
		sicknessView = SicknessScreen(frame: self.frame)
		self.addSubview(sicknessView)
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
	
	func initTrends() {
		trendsView = TrendsView(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height))
		self.addSubview(trendsView)
	}
	
	@objc func transisitionToMap(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.mapBlur.alpha = 0
			self.mapButton.alpha = 1
			self.sickButton.alpha = 0.5
			self.trendsButton.alpha = 0.5
			self.sicknessView.alpha = 0
			
			self.sicknessView.frame.origin.x = self.frame.width
			
			self.trendsView.frame.origin.x = self.frame.width
		})
	}
	
	@objc func transisitionToSick(_ sender: UIButton?) {
		if(sicknessView.frame.origin.x != 0) {
			if(trendsView.frame.origin.x == 0 && sicknessView.frame.origin.x < 0) {
				sicknessView.frame.origin.x = -self.frame.width
			} else {
				sicknessView.frame.origin.x = self.frame.width
			}
		}
		UIView.animate(withDuration: 0.5, animations: {
			self.mapBlur.alpha = 1
			
			self.mapButton.alpha = 0.5
			self.trendsButton.alpha = 0.5
			self.sickButton.alpha = 1
			
			self.sicknessView.alpha = 1
			self.sicknessView.frame.origin.x = 0
			self.trendsView.frame.origin.x = self.frame.width
			
		})
	}
	
	@objc func transisitionToTrends(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.mapBlur.alpha = 1
			self.mapButton.alpha = 0.5
			self.sickButton.alpha = 0.5
			self.trendsButton.alpha = 1
			
			self.sicknessView.alpha = 0
			self.sicknessView.frame.origin.x = -self.frame.width
			
			self.trendsView.frame.origin.x = 0
		})
	}
	
	func initChangeButtons() {
		initMapButton()
		initSickButton()
		initTrendsButton()
	}
	
	func initTrendsButton() {
		let trendsImage = UIImage(named: "trends.png")
		trendsButton = UIButton(frame: CGRect(x: self.frame.width - 55, y: self.frame.height - 65, width: 50, height: 50))
		trendsButton.backgroundColor = UIColor.clear
		trendsButton.addTarget(self, action: #selector(MainHolder.transisitionToTrends(_:)), for: .touchUpInside)
		trendsButton.setImage(trendsImage, for: .normal)
		trendsButton.alpha = 0.5
		self.addSubview(trendsButton)
	}
	
	func initSickButton() {
		let sickImage = UIImage(named: "sickness.png")
		sickButton = UIButton(frame: CGRect(x: self.frame.width/2 - 25, y: self.frame.height - 65, width: 50, height: 50))
		sickButton.backgroundColor = UIColor.clear
		sickButton.addTarget(self, action: #selector(MainHolder.transisitionToSick(_:)), for: .touchUpInside)
		sickButton.setImage(sickImage, for: .normal)
		sickButton.alpha = 1
		self.addSubview(sickButton)
	}
	
	func initMapButton() {
		let mapImage = UIImage(named: "globe2")
		mapButton = UIButton(frame: CGRect(x: 5, y: self.frame.height - 65, width: 50, height: 50))
		mapButton.backgroundColor = UIColor.clear
		mapButton.addTarget(self, action: #selector(MainHolder.transisitionToMap(_:)), for: .touchUpInside)
		mapButton.setImage(mapImage, for: .normal)
		mapButton.alpha = 0.5
		self.addSubview(mapButton)
	}
	
	func initSettings() {
		let settingsImage = UIImage(named: "settings.png")
		settingsButton = UIButton(frame: CGRect(x: 3*self.frame.width/32-self.frame.height/32, y: self.frame.height/16, width: self.frame.height/16, height: self.frame.height/16))
		settingsButton.backgroundColor = UIColor.clear
		settingsButton.setImage(settingsImage, for: .normal)
		settingsButton.addTarget(self, action: #selector(MainHolder.showSettings(_:)), for: .touchUpInside)
		settingsButton.window?.windowLevel = UIWindowLevelStatusBar
		self.addSubview(settingsButton)
	}
	
	@objc func showSettings(_ sender: UIButton?) {
		isSettings = true
		settings = SettingsView(frame: CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height), mainView: self)
		self.addSubview(settings)
		UIView.animate(withDuration: 0.5, animations: {
			self.settings.frame.origin.y += self.frame.height
		})
	}
	
	func refreshSicknessScreen() {
		if(sicknessView != nil) {
			let currentX = sicknessView.frame.origin.x
			sicknessView.removeFromSuperview()
			initSickness()
			sicknessView.frame.origin.x = currentX
			transisitionToSick(nil)
			self.bringSubview(toFront: settingsButton)
			self.bringSubview(toFront: mapButton)
			self.bringSubview(toFront: trendsButton)
			self.bringSubview(toFront: sickButton)
		}
	}
	
	func displayDiseaseSelector() {
		sicknessView.amSick(nil)
	}
	
	func initTransition() {
		transControls = TransitionControls(mainView: self)
	}
	
}

