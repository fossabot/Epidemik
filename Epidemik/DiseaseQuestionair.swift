//
//  DiseaseQuestionair.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/24/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class DiseaseQuestionair: UIView {
	
	var disease_name: String!
	var superScreen: SicknessScreen!
	var doneButton: UIButton!
	var insetX = CGFloat(30.0)
	var blur: UIVisualEffectView!

	var questions = Array<String>()
	
	public init(frame: CGRect, disease_name: String, superScreen: SicknessScreen) {
		super.init(frame: frame)
		self.disease_name = disease_name
		self.superScreen = superScreen
		self.questions = DISEASE_QUESTIONS.getDiseaseQuestions(diseaseName: disease_name)
		initBlur()
		myInitBlur()
		blur.frame = CGRect(x: 30, y: 100, width: self.frame.width-60, height: 4*self.frame.height/8)
		blur.layer.cornerRadius = 20
		blur.clipsToBounds = true
		initDoneButton()
		initSelectors()
		initTitle()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initTitle() {
		let title = UILabel(frame: CGRect(x: 20, y: 20, width: self.frame.width - 40, height: 60))
		title.text = "Testing Your Sickness"
		title.font = PRESETS.FONT_BIG_BOLD
		title.textAlignment = .center
		self.addSubview(title)
		
		let checkAllThatApply = UILabel(frame: CGRect(x: 20, y: 60, width: self.frame.width - 40, height: 20))
		checkAllThatApply.text = "(check all symptoms that apply)"
		checkAllThatApply.font = PRESETS.FONT_MEDIUM
		checkAllThatApply.textAlignment = .center
		self.addSubview(checkAllThatApply)
	}
	
	func initSelectors() {
		var yPos = 120
		for var question in self.questions {
			let checkbox = CheckBox(frame: CGRect(x: 40, y: yPos, width: 40, height: 40))
			let textBox = UILabel(frame: CGRect(x: 100, y: yPos, width: Int(self.frame.width - CGFloat(60)), height: 40))
			textBox.text = question
			textBox.font = PRESETS.FONT_BIG
			self.addSubview(textBox)
			self.addSubview(checkbox)
			yPos += 60
		}
	}
	
	func initDoneButton() {
		let buttonHeight = self.frame.height/6
		let doneYCord = 5*self.frame.height/8 + buttonHeight/2
		doneButton = UIButton(frame: CGRect(x: insetX, y: doneYCord, width: self.frame.width-2*insetX, height: buttonHeight))
		doneButton.layer.cornerRadius = 40
		doneButton.setTitle("Done", for: UIControlState.normal)
		doneButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		doneButton.backgroundColor = PRESETS.RED
		doneButton.addTarget(self, action: #selector(DiseaseQuestionair.amDone(_:)), for: .touchUpInside)
		self.addSubview(doneButton)
	}
	
	@objc func amDone(_ sender: UIButton?) {
		submit()
	}
	
	
	func submit() {
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x -= self.frame.width
			self.superScreen.healthyButton.frame.origin.x -= self.frame.width
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
	}
	
	func myInitBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
		blur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		blur.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height*5)
		blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(blur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
	
	
}
