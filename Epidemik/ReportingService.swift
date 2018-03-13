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
		let username = 	FileRW.readFile(fileName: "username.epi")

		let date = NSDate()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dateString = dateFormatter.string(from:date as Date)
		
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/recieveDisease.php")!)
		request.httpMethod = "POST"
		var postString = "date=" + dateString + "&username=" + username!
		postString = postString + "&disease_name=" + diseaseName
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
	
}
