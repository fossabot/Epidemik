//
//  ReportingService.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

public class Reporting {
	
	static var FILE_NAME = "sickness.epi"
	
	public static func amSick(diseaseName: String) {
		let address = FileRW.readFile(fileName: "address.epi")
		FileRW.writeFile(fileName: "sickness.epi", contents: "sick")
		
		let date = NSDate()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dateString = dateFormatter.string(from:date as Date)
		
		if (address != "" && diseaseName != "") {
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
				if(error != nil) {
				} else if let buffer = placemarks?[0] {
					let location = buffer.location;
					self.sendToServer(latitude: String(describing: location!.coordinate.latitude), longitude: String(describing: location!.coordinate.longitude), diseaseName: diseaseName, date: dateString)
					QuickTouch.initHealthyQuickTouch()
				} else {
				}
			})
		} else {
		}
	}
	
	static func sendToServer(latitude: String, longitude: String, diseaseName: String, date: String) {
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
	
	public static func amHealthy() {
		QuickTouch.initSickQuickTouch()
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
	
	static func isUserSick() -> Bool {
		return (FileRW.readFile(fileName: FILE_NAME) != nil && FileRW.readFile(fileName: FILE_NAME) != "")
	}
	
}
