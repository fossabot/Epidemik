//
//  PersonalTrendDataCenter
//  Epidemik
//
//  Created by Ryan Bradford on 2/17/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

public class PersonalTrendDataCenter {
	
	var datapoints = Array<Disease>()
	var loadingReactor: PersonalTrendLoadingReactor
	
	init(loadingReactor: PersonalTrendLoadingReactor) {
		self.loadingReactor = loadingReactor
	}
	
	// Loads the text from the server given a lat, long, lat width, long height
	// Calls the text->array, process, and draw
	func loadData() {
		print("loading")
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getPersonalData.php")!)
		request.httpMethod = "POST"
		let username = FileRW.readFile(fileName: "username.epi")!
		let postString = "username=" + username + "&get=true"
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
			print("loaded")
			self.loadingReactor.apply(t: 1)
		}
	}
	
	// Returns the date when you are most likely to get sick
	func getAverageDateSick() -> Date {
		var monthSum = 0.0
		var daySum = 0.0
		
		for disease in self.datapoints {
			monthSum = monthSum + Double(Calendar.current.component(Calendar.Component.month, from: disease.date))
			daySum = daySum + Double(Calendar.current.component(Calendar.Component.day, from: disease.date))

		}
		let month  = String(Int(round(monthSum/Double(datapoints.count))))
		let day  = String(Int(round(daySum/Double(datapoints.count))))
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM-dd"
		print(month + "-" + day)
		return dateFormatter.date(from: month + "-" + day)!
	}
	
	//Returns the average length you are sick for
	func getAverageLengthSickInDays() -> Double {
		var totalTime = 0.0
		for disease in datapoints {
			if(disease.date_healthy != disease.nullData) {
				totalTime = totalTime + disease.date_healthy.timeIntervalSince(disease.date)
			}
		}
		if(datapoints.count == 0) {
			return 0
		}
		return round(10.0*totalTime / (Double(datapoints.count)*86400.0)) / 10.0
	}
	
	//Returns how many times you are likely to get sick in a year
	func getSicknessPerYear() -> Double {
		if(datapoints.count == 0) {
			return 0
		} else {
			let totalLength = datapoints.last!.date.timeIntervalSince(datapoints.first!.date)
			if(totalLength == 0) {
				return Double(datapoints.count)
			}
			return round(10.0*Double(datapoints.count) / (totalLength/31540000)) / 10.0
		}
	}
	
}

