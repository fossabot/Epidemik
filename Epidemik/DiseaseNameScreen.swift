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
	
	var diseaseSelector: ScrollSelector!
	
	var superScreen: SicknessScreen!
	
	var searchBox: UITextField!
	
	let buttonInShift = CGFloat(25.0)
	let buttonUpShift = CGFloat(20.0)
	
	var questionair: DiseaseQuestionair!
	
	init (frame: CGRect, superScreen: SicknessScreen) {
		self.superScreen = superScreen
		super.init(frame: frame)
		initBlur()
		initSadFace()
		initDiseaseSelector()
		initTextBox()
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
		searchBox.font = PRESETS.FONT_BIG
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
	
	func initDiseaseSelectorTitle() {
		let selectorTitle = UITextView(frame: CGRect(x: 0, y: self.frame.width/2+30, width: self.frame.width, height: 30))
		selectorTitle.text = "Select Your Illness"
		selectorTitle.textAlignment = .center
		selectorTitle.backgroundColor = UIColor.clear
		selectorTitle.font = PRESETS.FONT_BIG
		selectorTitle.autocorrectionType = UITextAutocorrectionType.no
		self.addSubview(selectorTitle)
	}
	
	// A DiseaseSelector is a scrollable selector in the middle of the screen
	// Creates the selector that lets the user select which disease they have
	func initDiseaseSelector() {
		diseaseSelector = ScrollSelector(frame: CGRect(x: 0, y: 4*self.frame.height/16, width: self.frame.width, height: 3*self.frame.height/8), items: DISEASE_LIST.diseases)
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
		submitButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		submitButton.backgroundColor = PRESETS.RED
		submitButton.addTarget(self, action: #selector(gatherAndSendInfo), for: .touchUpInside)
		submitButton.layer.cornerRadius = 15
		self.addSubview(submitButton)
	}
	
	// A BackButton is a button in the bottom right of the screen
	// Creates the button that allows the user to go back to the sickness screen
	func initBackButton() {
		backButton = UIButton(frame: CGRect(x: buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2 - 2*buttonInShift, height: self.frame.height/4 - 2*buttonInShift))
		backButton.setTitle("BACK", for: .normal)
		backButton.backgroundColor = PRESETS.GRAY
		backButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
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
		questionair = DiseaseQuestionair(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), disease_name: diseaseSelector.timeTextField!.text!, superScreen: self.superScreen)
		superScreen.sicknessButton.removeFromSuperview()
		self.superScreen.addSubview(questionair)
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x -= self.frame.width
			self.questionair.frame.origin.x -= self.frame.width
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
	}
	
	// Recieves a button press from the send button and sends the sickness report to the server
	@objc func gatherAndSendInfo(_ sender: UIButton?) {
		Reporting.amSick(diseaseName: diseaseSelector.timeTextField!.text!)
		self.endEditing(true)
		self.superScreen.initHealthyButton()
		self.superScreen.healthyButton.frame.origin.x += self.frame.width
		self.forwards()
	}
	
	
}



