//
//  DiseaseNameScreen.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/25/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class DiseaseNameScreen: UIView {
	
	var sadFace: UIImageView!
	
	var backButton: UIButton!
	var submitButton: UIButton!
	
	var moreInfo: UIButton!
	
	var levelSelector: ButtonSelector!
	var diseaseSelector: ScrollSelector!
	
	var superScreen: SicknessScreen!
	
	var searchBox: UITextField!
	
	let buttonInShift = CGFloat(25.0)
	let buttonUpShift = CGFloat(20.0)
	
	init (frame: CGRect, superScreen: SicknessScreen) {
		self.superScreen = superScreen
		super.init(frame: frame)
		initSadFace()
		//initLevelSelector()
		initDiseaseSelector()
		//initDiseaseSelectorTitle()
		initTextBox()
		//initMoreInfoButton()
		initSendButton()
		initBackButton()
		self.backgroundColor = UIColor.clear
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// A SadFace is a (UIView centered at the middle-top of the screen)
	// Creates the sad face graphic on the screen
	func initSadFace() {
		let frame = CGRect(x: self.frame.width/4, y: 15, width: self.frame.width/2, height: self.frame.width/2)
		let image = UIImage(named: "sadface.png")
		sadFace = UIImageView(image: image)
		sadFace.frame = frame
		
		sadFace.backgroundColor = UIColor.clear
		self.addSubview(sadFace)
	}
	
	func initTextBox() {
		searchBox = UITextField(frame: CGRect(x: 0, y: self.frame.width/2+30, width: self.frame.width, height: 30))
		searchBox.textAlignment = .center
		searchBox.backgroundColor = UIColor.clear
		searchBox.font = UIFont(name: "Helvetica", size: 20)
		searchBox.text = "Search for your disease..."
		searchBox.clearsOnBeginEditing = true
		searchBox.addTarget(self, action: #selector(updateSearch), for: UIControlEvents.allEditingEvents)
		searchBox.addTarget(self, action: #selector(slideAllUp), for: UIControlEvents.editingDidBegin)
		searchBox.addTarget(self, action: #selector(slideAllDown), for: UIControlEvents.editingDidEnd)
		self.addSubview(searchBox)
	}
	
	@objc func updateSearch(_ sender: UITextField?) {
		diseaseSelector.limitItems(search: searchBox!.text!)
	}
	
	@objc func slideAllUp(_ sender: UITextField?) {
		let slideUp = self.frame.width/2 + 15
		UIView.animate(withDuration: 0.5, animations: {
			self.sadFace.frame.origin.y -= slideUp
			self.searchBox.frame.origin.y -= slideUp
			self.diseaseSelector.frame.origin.y -= slideUp
			self.submitButton.frame.origin.y -= slideUp
			self.backButton.frame.origin.y -= slideUp
		})
	}
	
	@objc func slideAllDown(_ sender: UITextField?) {
		if(sadFace.frame.origin.y > 0) {
			return
		}
		let slideDown = self.frame.width/2 + 15
		UIView.animate(withDuration: 0.5, animations: {
			self.sadFace.frame.origin.y += slideDown
			self.searchBox.frame.origin.y += slideDown
			self.diseaseSelector.frame.origin.y += slideDown
			self.submitButton.frame.origin.y += slideDown
			self.backButton.frame.origin.y += slideDown
		})
	}
	
	
	// A LevelSelector is a set of buttons in the middle of the screen
	// Creates the selector that lets the user say how sick they are
	func initLevelSelector() {
		levelSelector = ButtonSelector(frame: CGRect(x: 0, y: self.frame.height/4, width: self.frame.width, height: self.frame.height/4), items: ["1", "2" , "3", "4", "5"])
		self.addSubview(levelSelector)
	}
	
	func initDiseaseSelectorTitle() {
		let selectorTitle = UITextView(frame: CGRect(x: 0, y: self.frame.width/2+30, width: self.frame.width, height: 30))
		selectorTitle.text = "Select Your Illness"
		selectorTitle.textAlignment = .center
		selectorTitle.backgroundColor = UIColor.clear
		selectorTitle.font = UIFont(name: "Helvetica", size: 20)
		selectorTitle.autocorrectionType = UITextAutocorrectionType.no
		self.addSubview(selectorTitle)
	}
	
	// A DiseaseSelector is a scrollable selector in the middle of the screen
	// Creates the selector that lets the user select which disease they have
	func initDiseaseSelector() {
		diseaseSelector = ScrollSelector(frame: CGRect(x: 0, y: 4*self.frame.height/16, width: self.frame.width, height: 3*self.frame.height/8), items: ["Common Cold", "Flu" , "Measels", "Mumps", "Other"])
		self.addSubview(diseaseSelector)
	}
	
	// A MoreInfo is a button in the bottom middle of the screen
	// Creates the button that allows the user to request to enter more information
	func initMoreInfoButton() {
		moreInfo = UIButton(frame: CGRect(x: 0, y: self.frame.height/2, width: self.frame.width, height: self.frame.height/4))
		moreInfo.backgroundColor = UIColor.cyan
		
		self.addSubview(moreInfo)
	}
	
	// A SendButton is a button in the bottom right of the screen
	// Creates the button that allows the user to send their sickness data to the server
	func initSendButton() {
		submitButton = UIButton(frame: CGRect(x: self.frame.width/2+buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2-2*buttonInShift, height: self.frame.height/4-2*buttonInShift))
		submitButton.setTitle("SUBMIT", for: .normal)
		submitButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
		submitButton.backgroundColor = COLORS.COLOR_2
		submitButton.addTarget(self, action: #selector(gatherAndSendInfo), for: .touchUpInside)
		submitButton.layer.cornerRadius = 15
		self.addSubview(submitButton)
	}
	
	// A BackButton is a button in the bottom right of the screen
	// Creates the button that allows the user to go back to the sickness screen
	func initBackButton() {
		backButton = UIButton(frame: CGRect(x: buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2 - 2*buttonInShift, height: self.frame.height/4 - 2*buttonInShift))
		backButton.setTitle("BACK", for: .normal)
		backButton.backgroundColor = COLORS.COLOR_4
		backButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		backButton.layer.cornerRadius = 15
		self.addSubview(backButton)
	}
	
	// Recieves the press from the back button and slides the disease selection screen to the right
	@objc func back(_ sender: UIButton?) {
		superScreen.addSubview(superScreen.sicknessButton)
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x += self.frame.width
			self.superScreen.sicknessButton.frame.origin.x += self.frame.width
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
	}
	
	// Slides the disease selection screen on-screen and moves the healthy button off screen
	func forwards() {
		superScreen.sicknessButton.removeFromSuperview()
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x -= self.frame.width
			self.superScreen.healthyButton.frame.origin.x -= self.frame.width
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
	}
	
	// Recieves a button press from the send button and sends the sickness report to the server
	@objc func gatherAndSendInfo(_ sender: UIButton?) {
		let address = FileRW.readFile(fileName: "address.epi")
		let diseaseName = diseaseSelector.timeTextField?.text
		
		let date = NSDate()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dateString = dateFormatter.string(from:date as Date)
		
		if (address != "" && diseaseName != "") {
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
				if(error != nil) {
					self.setError()
				} else if let buffer = placemarks?[0] {
					let location = buffer.location;
					self.endEditing(true)
					self.sendToServer(latitude: String(describing: location!.coordinate.latitude), longitude: String(describing: location!.coordinate.longitude), diseaseName: diseaseName!, date: dateString)
					self.superScreen.initHealthyButton()
					self.superScreen.healthyButton.frame.origin.x += self.frame.width
					self.forwards()
				} else {
					self.setError()
				}
			})
		} else {
			setError()
		}
	}
	
	// Sends the sickness data to the server
	func sendToServer(latitude: String, longitude: String, diseaseName: String, date: String) {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/recieveDisease.php")!)
		request.httpMethod = "POST"
		let postString = "date="+date + "&latitude=" + latitude + "&longitude=" + longitude
			+ "&disease_name=" + diseaseName + "&deviceID=" + UIDevice.current.identifierForVendor!.uuidString
		FileRW.writeFile(fileName: "sickness.epi", contents: postString)
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
			print(responseString ?? "")
		}
		task.resume()
	}
	
	func setError() {
		
	}
	
	
}



