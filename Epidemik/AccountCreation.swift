//
//  AccountCreation.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/3/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications

class LoginScreen: UIView, UITextFieldDelegate {

	var FILE_NAME = "username.epi"
	
	var usernameTextBox: UITextField!
	var passwordTextBox: UITextField!
	var addressTextBox: UITextField?
	
	var shouldAdd: Bool = true
	
	var loginButton: UIButton!
	
	var vc = UIApplication.shared.delegate?.window??.rootViewController as! ViewController
	
	var username: String?
	var password: String?
	var latitude: Double?
	var longitude: Double?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initTextBoxes()
		addLoginButton()
		addCreateAccountButton()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func login(username: String, password: String) {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Notifications/recieveDeviceID.php")!)
		request.httpMethod = "POST"
		let postString = "username=" + username + "&password=" + password + "&login=true"
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
			if(responseString != nil && responseString == "1") {
				FileRW.writeFile(fileName: self.FILE_NAME, contents: username)
				DispatchQueue.main.sync {
					self.endEditing(true)
					self.slideSelfAway(duration: 0.5)
				}
			} else {
				DispatchQueue.main.sync {
					self.endEditing(true)
					self.warnUser(message: "your login was incorrect")
				}
			}
			
		}
		task.resume()
	}
	
	// Tells the Holder if this view should be added
	func setShouldAdd() {
		let currentUsername = FileRW.readFile(fileName: FILE_NAME)
		self.shouldAdd = currentUsername == nil || currentUsername == ""
	}
	
	//Tells the user that their login was incorrect
	func warnUser(message: String) {
		usernameTextBox.text = message
		passwordTextBox.text = ""
		if(addressTextBox != nil) {
			addressTextBox!.text = ""
		}
	}
	
	//Called when the app has verified the address
	func slideSelfAway(duration: Double) {
		self.vc.initMainScreen()
		UIView.animate(withDuration: duration, animations: {
			self.frame.origin.y -= self.frame.height
		})
	}
	
	func initTextBoxes() {
		usernameTextBox = UITextField(frame: CGRect(x: 20, y: self.frame.height/2 - 200, width: self.frame.width - 40, height: 50))
		usernameTextBox.backgroundColor = UIColor.blue
		usernameTextBox.autocorrectionType = .no
		usernameTextBox.autocapitalizationType = .none
		usernameTextBox.delegate = self
		self.addSubview(usernameTextBox)
		
		passwordTextBox = UITextField(frame: CGRect(x: 20, y: self.frame.height/2 - 100, width: self.frame.width - 40, height: 50))
		passwordTextBox.backgroundColor = UIColor.blue
		passwordTextBox.autocorrectionType = .no
		passwordTextBox.autocapitalizationType = .none
		passwordTextBox.delegate = self
		self.addSubview(passwordTextBox)
	}
	
	func addLoginButton() {
		loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
		loginButton.backgroundColor = UIColor.red
		loginButton.addTarget(self, action: #selector(LoginScreen.loginReactor(_:)), for: .touchUpInside)
		self.addSubview(loginButton)
	}
	
	
	@objc func loginReactor(_ sender: UIButton?) {
		self.login(username: self.usernameTextBox.text!, password: self.passwordTextBox.text!)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.endEditing(true)
		return false
	}
	
	@objc func accCreateInitReactor(_ sender: UIButton?) {
		addressTextBox = UITextField(frame: CGRect(x: 20, y: self.frame.height/2, width: self.frame.width-40, height: 50))
		addressTextBox!.backgroundColor = UIColor.blue
		addressTextBox!.autocorrectionType = .no
		addressTextBox!.autocapitalizationType = .none
		addressTextBox!.delegate = self
		self.addSubview(addressTextBox!)
		
		loginButton.removeTarget(self, action: #selector(LoginScreen.loginReactor(_:)), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(LoginScreen.accCreateReactor(_:)), for: .touchUpInside)
	}
	
	func addCreateAccountButton() {
		let createAcc = UIButton(frame: CGRect(x: 0, y: self.frame.height/2+100, width: self.frame.width, height: 50))
		createAcc.backgroundColor = UIColor.green
		createAcc.addTarget(self, action: #selector(LoginScreen.accCreateInitReactor(_:)), for: .touchUpInside)
		self.addSubview(createAcc)
	}
	
	@objc func accCreateReactor(_ sender: UIButton?) {
		let address = addressTextBox!.text!
		let username = usernameTextBox.text!
		let password = passwordTextBox.text!
		if (address != "") {
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
				if let buffer = placemarks?[0] {
					let location = buffer.location;
					self.askForNotifications(username: username, password: password, latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
				}
			})
		} else {
			warnUser(message: "please enter a valid address")
		}
	}
	
	func askForNotifications(username: String, password: String, latitude: Double, longitude: Double) {
		self.username = username
		self.password = password
		self.longitude = longitude
		self.latitude = latitude
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.accCreation = self
		UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]){ (granted, error) in }
		UIApplication.shared.registerForRemoteNotifications()
	}
	
	func createAccount(deviceID: String) {
		var postString = "username=" + username!
		postString += "&password=" + password!
		postString += "&latitude=" + String(latitude!)
		postString += "&longitude=" + String(longitude!)
		postString += "&deviceID=" + deviceID
		postString += "&create=" + "true"
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Notifications/recieveDeviceID.php")!)
		request.httpMethod = "POST"
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
			if(responseString != nil && responseString == "1") {
				FileRW.writeFile(fileName: self.FILE_NAME, contents: self.username!)
				DispatchQueue.main.sync {
					self.endEditing(true)
					self.slideSelfAway(duration: 0.5)
				}
			} else {
				DispatchQueue.main.sync {
					self.endEditing(true)
					self.warnUser(message: "this login already exists")
				}
			}
			
		}
		task.resume()

	}
	
	
}
