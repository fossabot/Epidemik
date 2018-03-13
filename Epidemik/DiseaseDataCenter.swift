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
	var loadingReactor: DiseaseLoadingReactor
	
	init(loadingReactor: DiseaseLoadingReactor) {
		self.loadingReactor = loadingReactor
	}
	
	// Loads the text from the server given a lat, long, lat width, long height
	// Calls the text->array, process, and draw
	func loadDiseasePointData() {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getCurrentData.php")!)
		request.httpMethod = "POST"
		let postString = "get=true"
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
		for line in latArray {
			self.datapoints.append(Disease(text: String(line)))
		}
		DispatchQueue.main.sync {
			self.loadingReactor.apply(t: 1)
		}
	}
	
	func getAppropriateData(date: Date) -> Array<Disease> {
		let toReturn = datapoints.filter({
			($0.date_healthy > date && $0.date < date)
		})
		return toReturn
	}
	
}
