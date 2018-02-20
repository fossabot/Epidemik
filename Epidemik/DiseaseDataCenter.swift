//
//  DiseasePointCenter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/17/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

public class DiseaseDataCenter {
	
	var datapoints = Array<Disease>()
	var diseaseReactor: DiseaseLoadingReactor
	
	init(diseaseReactor: DiseaseLoadingReactor) {
		self.diseaseReactor = diseaseReactor
		loadDiseasePointData()
	}
	
	// Loads the text from the server given a lat, long, lat width, long height
	// Calls the text->array, process, and draw
	func loadDiseasePointData() {
		let latitude = -1000
		let longitude = -1000
		let rangeLong = 2000
		let rangeLat = 2000
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getCurrentData.php")!)
		request.httpMethod = "POST"
		let postString = "latitude=" + String(latitude) + "&longitude=" + String(longitude) +
			"&rangeLong=" + String(rangeLong) + "&rangeLat=" + String(rangeLat)
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
			self.loadDiseaseTextToArray(toDraw: responseString!)
		}
		task.resume()
	}
	
	// Processes the text from the server and loads it to a local array
	func loadDiseaseTextToArray(toDraw: String) {
		let latArray = toDraw.split(separator: "\n")
		for lat in 0 ..< latArray.count {
			let longArray = latArray[lat].split(separator: ",")
			let latitude = (Double(longArray[0])!)
			let longitude = (Double(longArray[1])!)
			let name = String(longArray[2])
			let date = String(longArray[3])
			var date_healthy = String(longArray[4])
			date_healthy = date_healthy.trimmingCharacters(in: CharacterSet.init(charactersIn: "\""))
			let newDisease = Disease(lat: latitude, long: longitude, diseaseName: name, date: date, date_healthy: date_healthy)
			self.datapoints.append(newDisease)
		}
		DispatchQueue.main.sync {
			self.diseaseReactor.apply(t: 1)
		}
	}
	
	func getAppropriateData(date: Date) -> Array<Disease> {
		let toReturn = datapoints.filter({
			($0.date_healthy > date && $0.date < date)
		})
		return toReturn
	}
	
}
