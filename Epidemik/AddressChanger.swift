//
//  AddressChanger.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/13/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import UserNotifications

class ADDRESS {
	
	public static var FILE_NAME = "address.epi"
	
	public static func askForNewAddress(message: String) {
		Asker.ask(title: "Address", placeHolder: "1 Main St. New York, NY", message: message, isSecure: false, resp: AddressResponse())
	}
	
	public static func convertToCordinates(address: String) {
		if (address != "") {
			FileRW.writeFile(fileName: ADDRESS.FILE_NAME, contents: address)
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
				if let buffer = placemarks?[0] {
					let location = buffer.location;
					self.sendToServer(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
				}
			})
		} else {
			setError()
		}
	}
	
	static func sendToServer(latitude: Double, longitude: Double) {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/changeAddress.php")!)
		request.httpMethod = "POST"
		let username = FileRW.readFile(fileName: "username.epi")!
		let postString = "username=" + username + "&latitude=" + String(latitude) + "&longitude=" + String(longitude)
		print(postString)
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
			print(responseString)
		}
		task.resume()
	}
	
	public static func setError() {
		askForNewAddress(message: "Please Enter A Valid Address")
	}
	
}


