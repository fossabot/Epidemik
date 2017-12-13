//
//  SettingsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/12/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CoreLocation

public class SettingsView: UIView {
	
	var smallButtonWidth: CGFloat!
	var smallButtonHeight: CGFloat!
	var smallButtonGap: CGFloat!
	
	var addressChanger: UIButton!
	var detailSelector: BarSelector!
	
	var mainView: MainHolder!
	
	var FILE_NAME = "address.epi"
	
	public init(frame: CGRect, mainView: MainHolder) {
		self.mainView = mainView
		super.init(frame: frame)
		smallButtonWidth = 3*frame.width/5
		smallButtonHeight = self.frame.height/8
		smallButtonGap = self.frame.height/16
		
		self.backgroundColor = COLORS.COLOR_1
		initAddressChanger()
		initDone()
		initDetailSelector()
	}
	
	func initAddressChanger() {
		addressChanger = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: smallButtonGap, width: smallButtonWidth, height: smallButtonHeight))
		addressChanger.backgroundColor = COLORS.COLOR_4
		addressChanger.addTarget(self, action: #selector(SettingsView.changeAddress(_:)), for: .touchUpInside)
		addressChanger.layer.cornerRadius = 20
		addressChanger.titleLabel?.font = UIFont(name: "Helvetica", size: 23)
		addressChanger.setTitle("Change Address", for: .normal)
		self.addSubview(addressChanger)
	}
	
	@objc func changeAddress(_ sender: UIButton?) {
		updateDeviceToken()
		getAddress(message: "What is Your New Address?")
	}
	
	func getAddress(message: String) {
		let alert = UIAlertController(title: "Address", message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
			let textf1 = alert.textFields![0] as UITextField
			self.convertToCordinates(address: textf1.text!)
		}))
		alert.addTextField(configurationHandler: {(textField: UITextField) in
			textField.placeholder = "1 Main St. New York, NY"
			textField.isSecureTextEntry = false
		})
		UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
	}
	
	func convertToCordinates(address: String) {
		if (address != "") {
			FileRW.writeFile(fileName: self.FILE_NAME, contents: address)
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
				if(error != nil) {
					self.setError()
				} else if let buffer = placemarks?[0] {
					let location = buffer.location;
					self.endEditing(true)
					let appDelegate = UIApplication.shared.delegate as! AppDelegate
					appDelegate.sendDeviceTokenToServer(latitude: String(describing: location!.coordinate.latitude), longitude: String(describing: location!.coordinate.longitude), transition: nil)
				} else {
					self.setError()
				}
			})
		} else {
			setError()
		}
	}
	
	func setError() {
		getAddress(message: "Please Enter A Valid Address")
	}
	
	func updateDeviceToken() {
		UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]){ (granted, error) in }
		UIApplication.shared.registerForRemoteNotifications()
	}
	
	func initDetailSelector() {
		detailSelector = DetailSelector(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 2*smallButtonGap+smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight), overlayCreator: mainView.mapView.overlayCreator)
		self.addSubview(detailSelector)
	}
	
	func initDone() {
		let done = UIButton(frame: CGRect(x: 20, y: 3*self.frame.height/4, width: self.frame.width-40, height: self.frame.height/5))
		done.backgroundColor = COLORS.COLOR_3
		done.addTarget(self, action: #selector(SettingsView.removeSelf(_:)), for: .touchUpInside)
		done.layer.cornerRadius = 20
		done.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 30)
		done.setTitle("Done", for: .normal)
		self.addSubview(done)
	}
	
	@objc func removeSelf(_ sender: UIButton?) {
		
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.y -= self.frame.height
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
