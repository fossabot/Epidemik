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
	
	var usernameTextBox: AccCreationTextBox!
	var passwordTextBox: AccCreationTextBox!
	var addressTextBox: AccCreationTextBox?
	
	var shouldAdd: Bool = true
	
	var loginButton: UIButton!
	var loginButtonLabel: UILabel!
	
	var createAccButton: UIButton!
	
	var logoImageView: UIImageView!
	
	var vc = UIApplication.shared.delegate?.window??.rootViewController as! ViewController
	
	var username: String?
	var password: String?
	var latitude: Double?
	var longitude: Double?
	
	var slidUp = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setShouldAdd()
		self.backgroundColor = UIColor.white
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func draw(_ rect: CGRect) {
		initTextBoxes()
		addLoginButton()
		addCreateAccountButton()
		addLogo()
		self.backgroundColor = UIColor.white
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
		let selfHeight = self.frame.height / 15.0
		let xOffset = self.frame.width / 12
		let usernameImage = UIImage(named: "username.png")
		usernameTextBox = AccCreationTextBox(frame: CGRect(x: xOffset, y: self.frame.height/2 - 3.0*selfHeight/2.0, width: self.frame.width - 2.0*xOffset, height: selfHeight), toDisplay: usernameImage!)
		usernameTextBox.delegate = self
		usernameTextBox.text = "username"
		self.addSubview(usernameTextBox)
		
		let passwordImage = UIImage(named: "password.png")
		passwordTextBox = AccCreationTextBox(frame: CGRect(x: xOffset, y: self.frame.height/2 + selfHeight / 2, width: self.frame.width - 2*xOffset, height: selfHeight), toDisplay: passwordImage!)
		passwordTextBox.isSecureTextEntry = true
		passwordTextBox.delegate = self
		passwordTextBox.text = "password"
		self.addSubview(passwordTextBox)
	}
	
	func addLoginButton() {
		let xOffset = self.frame.width / 12
		let width = self.frame.width - 2.0*xOffset
		let height = self.frame.height / 15
		loginButton = UIButton(frame: CGRect(x: xOffset, y: self.frame.height / 2 + 5*height/2, width: width, height: height))
		loginButton.backgroundColor = UIColor(displayP3Red: 0.95, green: 0.92, blue: 0.92, alpha: 1)
		loginButton.addTarget(self, action: #selector(LoginScreen.loginReactor(_:)), for: .touchUpInside)
		let text = UILabel()
		text.text = "Login"
		text.font = UIFont(name: "Futura-CondensedMedium", size: 20)
		text.frame = CGRect(x: 0, y: 0, width: width, height: height)
		text.textAlignment = .center
		loginButton.addSubview(text)
		self.addSubview(loginButton)
	}
	
	@objc func loginReactor(_ sender: UIButton?) {
		self.login(username: self.usernameTextBox.text!, password: self.passwordTextBox.text!)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.endEditing(true)
		if(!slidUp) {
			return false
		}
		slidUp = false
		UIView.animate(withDuration: 0.5, animations: {
			self.usernameTextBox.frame.origin.y += self.frame.height/4
			self.passwordTextBox.frame.origin.y += self.frame.height/4
			self.addressTextBox?.frame.origin.y += self.frame.height/4
			self.logoImageView.frame.origin.y += self.frame.height/4
			self.loginButton.frame.origin.y += self.frame.height/4
		})
		return false
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if(slidUp) {
			return
		}
		slidUp = true
		UIView.animate(withDuration: 0.5, animations: {
			self.usernameTextBox.frame.origin.y -= self.frame.height/4
			self.passwordTextBox.frame.origin.y -= self.frame.height/4
			self.addressTextBox?.frame.origin.y -= self.frame.height/4
			self.logoImageView.frame.origin.y -= self.frame.height/4
			self.loginButton.frame.origin.y -= self.frame.height/4
		})
	}
	
	@objc func accCreateInitReactor(_ sender: UIButton?) {
		let xOffset = self.frame.width / 12
		let width = self.frame.width - 2.0*xOffset
		let height = self.frame.height / 15
		let addressImage = UIImage(named: "address.png")
		addressTextBox = AccCreationTextBox(frame: CGRect(x: self.frame.width, y: self.frame.height/2 + 5*height/2.0, width: width, height: height), toDisplay: addressImage!)
		addressTextBox?.text = "address"
		addressTextBox!.delegate = self
		self.addSubview(addressTextBox!)
		
		loginButton.removeTarget(self, action: #selector(LoginScreen.loginReactor(_:)), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(LoginScreen.accCreateReactor(_:)), for: .touchUpInside)
		
		self.loginButtonLabel.text = "Create A New Account"
		
		UIView.animate(withDuration: 0.5, animations: {
			self.loginButton.frame.origin.y += 3*height/2
			self.addressTextBox?.frame.origin.x = xOffset
			self.createAccButton.frame.origin.x -= self.frame.width
		})
	}
	
	func addCreateAccountButton() {
		let selfHeight = self.frame.height / 12
		let selfWidth = 5*self.frame.width / 12
		createAccButton = UIButton(frame: CGRect(x: (self.frame.width - selfWidth) / 2, y: self.frame.height - selfHeight, width: selfWidth, height: selfHeight))
		createAccButton.backgroundColor = UIColor.clear
		self.loginButtonLabel = UILabel()
		self.loginButtonLabel.text = "Create an Account"
		self.loginButtonLabel.font = UIFont(name: "Futura-CondensedMedium", size: 12)
		self.loginButtonLabel.frame = CGRect(x: 0, y: 0, width: selfWidth, height: selfHeight)
		self.loginButtonLabel.textAlignment = .center
		createAccButton.addSubview(self.loginButtonLabel)
		createAccButton.addTarget(self, action: #selector(LoginScreen.accCreateInitReactor(_:)), for: .touchUpInside)
		self.addSubview(createAccButton)
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
				} else {
					self.warnUser(message: "please enter a valid address")
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
	
	func addLogo() {
		let epidemikImage = UIImage(named: "epidemik.png")
		let imageWidth = self.frame.width / 3
		logoImageView = UIImageView(frame: CGRect(x: (self.frame.width - imageWidth)/2, y: self.frame.height
			/ 20, width: imageWidth, height: imageWidth))
		logoImageView.image = epidemikImage
		self.addSubview(logoImageView)
	}
	
	
}
