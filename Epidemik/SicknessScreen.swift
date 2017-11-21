//
//  SicknessScreen.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/25/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class SicknessScreen: UIView {
	
	var insetX = 30.0
	var FILE_NAME = "sickness.epi"
	
	var healthyButton: UIButton!
	public var sicknessButton: UIButton!
	
	var buttonWidth: CGFloat!
	var buttonHeight: CGFloat!
	
	let buttonChampher = CGFloat(40.0)
	let buttonFont = UIFont(name: "Helvetica-Bold", size: 22)
	
	override init (frame: CGRect) {
		super.init(frame: frame)
		initButtonPerams()
		initButton()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initButtonPerams() {
		buttonHeight = self.frame.height/6
		buttonWidth = 7*CGFloat(insetX)
	}
	
	// Inits the button that the user can press
	// If they are already sick, it will Say "Healthy Again!"
	// If they are healthy, it will say "Sick :("
	func initButton() {
		print(FileRW.readFile(fileName: FILE_NAME))
		if (FileRW.readFile(fileName: FILE_NAME) == nil || FileRW.readFile(fileName: FILE_NAME) == "") {
			initSickButton(x: self.frame.width/2 - buttonWidth/2)
		} else {
			initHealthyButton()
		}
	}
	
	// Creates the button that the user can press to say they are sick
	func initSickButton(x: CGFloat) {
		sicknessButton = UIButton(frame: CGRect(x: x, y: self.frame.height/2 - buttonHeight/2, width: buttonWidth, height: buttonHeight))
		sicknessButton.layer.cornerRadius = buttonChampher
		sicknessButton.setTitle("SICK :(", for: UIControlState.normal)
		sicknessButton.titleLabel?.font = buttonFont
		sicknessButton.backgroundColor = COLORS.COLOR_1
		sicknessButton.addTarget(self, action: #selector(SicknessScreen.amSick(_:)), for: .touchUpInside)
		self.addSubview(sicknessButton)
	}
	
	// Handles Sickness button presses
	// - Creates the disease name categorizer
	// UIButton -> Nothing
	@objc func amSick(_ sender: UIButton?) {		
		let diseaseSelector = DiseaseNameScreen(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), superScreen: self)
		self.addSubview(diseaseSelector)
		UIView.animate(withDuration: 0.5, animations: {
			self.sicknessButton.frame.origin.x -= self.frame.width
			diseaseSelector.frame = self.frame
		}, completion: {
			(value: Bool) in
			self.sicknessButton.removeFromSuperview()
		})
	}
	
	// Creates the button that the user can say they are healthy in
	func initHealthyButton() {
		healthyButton = UIButton(frame: CGRect(x: self.frame.width/2 - buttonWidth/2, y: self.frame.height/2 - buttonHeight/2, width: buttonWidth, height: buttonHeight))
		healthyButton.layer.cornerRadius = buttonChampher
		healthyButton.backgroundColor = COLORS.COLOR_5
		healthyButton.titleLabel?.font = buttonFont
		healthyButton.setTitleColor(UIColor.black, for: .normal)
		healthyButton.setTitle("HEALTHY!", for: UIControlState.normal)
		healthyButton.addTarget(self, action: #selector(SicknessScreen.amHealthy(_:)), for: .touchUpInside)
		self.addSubview(healthyButton)
	}
	
	// Handles the healthy press
	// Wipes the current sickness report from the server
	// Puts the sickness button on the screen
	@objc func amHealthy(_ sender: UIButton?) {
		clearCurrentData()
		replaceHealthyButton()
	}
	
	// Slides the healthy button to the left and the sickness button in from the right
	func replaceHealthyButton() {
		if(sicknessButton != nil) {
			sicknessButton.removeFromSuperview()
		}
		initSickButton(x: self.frame.width/2 - buttonWidth/2 + 2*self.frame.width)
		let smileyView = UIImageView(image: UIImage(named: "smiley"))
		smileyView.frame = CGRect(x: 1*self.frame.width+(self.frame.width-self.frame.height/4)/2, y: 3*self.frame.height/8, width: self.frame.height/4, height: self.frame.height/4)
		self.addSubview(smileyView)
		UIView.animate(withDuration: 0.8, animations: {
			smileyView.frame.origin.x -= 2*self.frame.width
			self.healthyButton.frame.origin.x -= 2*self.frame.width
			self.sicknessButton.frame.origin.x -= 2*self.frame.width
		}, completion: {
			(value: Bool) in
			self.healthyButton.removeFromSuperview()
			smileyView.removeFromSuperview()
		})
		
	}
	
	// Sends the prior post request to the server and clears it from the database
	// Also wipes the file from the phone
	func clearCurrentData() {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/recieveDisease.php")!)
		request.httpMethod = "POST"
		if(!FileRW.fileExists(fileName: FILE_NAME)) {
			return
		}
		var postString = FileRW.readFile(fileName: FILE_NAME)! as String
		postString += "&delete=true"
		FileRW.writeFile(fileName: FILE_NAME, contents: "")
		request.httpBody = postString.data(using: .utf8)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard let _ = data, error == nil else {
				print("error=\(String(describing: error))")
				return
			}
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				print("response = \(String(describing: response))")
				return
			}
			let responseString = String(data: data!, encoding: .utf8)
		}
		task.resume()
	}
	
}
