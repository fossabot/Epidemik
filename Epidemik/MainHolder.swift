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
	var trendsView: GTrendsView!
	var personalTrends: PTrendsView!
	
	var mapButton: UIButton!
	var pTrendsButton: UIButton!
	var gTrendsButton: UIButton!
	
	var settingsButton: UIButton!
	
	var settings: SettingsView!
	var isSettings = false
	
	var transControls: TransitionControls!
	
	var dataCenter: DataCenter!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initMap()
		initPersonalTrends()
		initTrends()
		initSettings()
		initTransition()
		initData()
		initSickness()
		initChangeButtons()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initData() {
		self.dataCenter = DataCenter(diseaseReactor: DiseaseLoadingReactor(map: self.mapView), trendReactor: TrendLoadingReactor(trendsView: self.trendsView))
		self.mapView.dataCenter = self.dataCenter
		self.trendsView.dataCenter = self.dataCenter
	}
	
	func initSickness() {
		sicknessView = SicknessScreen(frame: self.frame, mainHolder: self)
		self.addSubview(sicknessView)
	}
	
	func initMap() {
		let leftFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
		mapView = Map(frame: leftFrame, realLatWidth: 5000, realLongWidth: 5000, startLong: -71.0628642, startLat: 42.4706918)
		self.addSubview(mapView)
	}
	
	func initTrends() {
		trendsView = GTrendsView(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height))
		self.addSubview(trendsView)
	}
	
	func initPersonalTrends() {
		personalTrends = PTrendsView(frame: CGRect(x: -self.frame.width, y:0, width: self.frame.width, height: self.frame.height))
		self.addSubview(personalTrends)
	}
	
	@objc func transisitionToMap(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.mapButton.alpha = 1
			self.pTrendsButton.alpha = 0.5
			self.gTrendsButton.alpha = 0.5
			self.sicknessView.alpha = 0
			
			self.personalTrends.frame.origin.x = -self.frame.width
			
			self.trendsView.frame.origin.x = self.frame.width
		})
	}
	
	@objc func transisitionToPTrends(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.mapButton.alpha = 0.5
			self.gTrendsButton.alpha = 0.5
			self.pTrendsButton.alpha = 1
			
			self.personalTrends.alpha = 1
			self.personalTrends.frame.origin.x = 0
			self.trendsView.frame.origin.x = self.frame.width
			
		})
	}
	
	@objc func transisitionToGTrends(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.mapButton.alpha = 0.5
			self.pTrendsButton.alpha = 0.5
			self.gTrendsButton.alpha = 1
			
			self.personalTrends.alpha = 0
			self.personalTrends.frame.origin.x = -self.frame.width
			
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
		gTrendsButton = UIButton(frame: CGRect(x: self.frame.width - 55, y: self.frame.height - 65, width: 50, height: 50))
		gTrendsButton.backgroundColor = UIColor.clear
		gTrendsButton.addTarget(self, action: #selector(MainHolder.transisitionToGTrends(_:)), for: .touchUpInside)
		gTrendsButton.setImage(trendsImage, for: .normal)
		gTrendsButton.alpha = 0.5
		self.addSubview(gTrendsButton)
	}
	
	func initSickButton() {
		let sickImage = UIImage(named: "sickness.png")
		pTrendsButton = UIButton(frame: CGRect(x: 5, y: self.frame.height - 65, width: 50, height: 50))
		pTrendsButton.backgroundColor = UIColor.clear
		pTrendsButton.addTarget(self, action: #selector(MainHolder.transisitionToPTrends(_:)), for: .touchUpInside)
		pTrendsButton.setImage(sickImage, for: .normal)
		pTrendsButton.alpha = 0.5
		self.addSubview(pTrendsButton)
	}
	
	func initMapButton() {
		let mapImage = UIImage(named: "globe2")
		mapButton = UIButton(frame: CGRect(x: self.frame.width/2 - 25, y: self.frame.height - 65, width: 50, height: 50))
		mapButton.backgroundColor = UIColor.clear
		mapButton.addTarget(self, action: #selector(MainHolder.transisitionToMap(_:)), for: .touchUpInside)
		mapButton.setImage(mapImage, for: .normal)
		mapButton.alpha = 1
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
			self.bringSubview(toFront: settingsButton)
			self.bringSubview(toFront: mapButton)
			self.bringSubview(toFront: gTrendsButton)
			self.bringSubview(toFront: pTrendsButton)
		}
	}
	
	func displayDiseaseSelector() {
		sicknessView.amSick(nil)
	}
	
	func initTransition() {
		transControls = TransitionControls(mainView: self)
	}
	
	func removeSickness() {
		UIView.animate(withDuration: 0.5, animations: {
			self.sicknessView.frame.origin.y -= self.frame.height
		})
	}
	
}

