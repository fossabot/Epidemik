//
//  StatusDataCenter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

class StatusDataCenter {
	
	var sicknessScreen: SicknessScreen!
	
	init(sicknessScreen: SicknessScreen) {
		self.sicknessScreen = sicknessScreen
	}
	
	//Inits the sickness buttons and writes the post string if applicable
	func getUserStatus() {
		print("loading")
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getPersonalStatus.php")!)
		request.httpMethod = "POST"
		let username = FileRW.readFile(fileName: "username.epi")!
		let postString = "username=" + username
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
			if(responseString == "" || responseString == nil) {
				DispatchQueue.main.sync {
					self.sicknessScreen.initButton(isSick: false)
				}
			} else {
				FileRW.writeFile(fileName: "sickness.epi", contents: responseString!)
				DispatchQueue.main.sync {
					self.sicknessScreen.initButton(isSick: true)
				}
			}
		}
		task.resume()
	}
}
