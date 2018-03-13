//
//  Disease.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/11/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation

public class Disease {
	
	var lat: Double
	var long: Double
	var diseaseName: String
	var date: Date
	var date_healthy: Date
	
	var nullData: Date
	
	init(lat: Double, long: Double, diseaseName: String, date: String, date_healthy: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date_healthy = dateFormatter.date(from: date_healthy)!

		self.lat = lat
		self.long = long
		self.diseaseName = diseaseName
    
		self.date = dateFormatter.date(from: date)!
		
		self.nullData = dateFormatter.date(from: "4099-11-30")!
	}
	
	convenience init(text: String) {
		let longArray = text.split(separator: ",")
		let latitude = (Double(longArray[0])!)
		let longitude = (Double(longArray[1])!)
		let name = String(longArray[2])
		let date = String(longArray[3])
		var date_healthy = String(longArray[4])
		date_healthy = date_healthy.trimmingCharacters(in: CharacterSet.init(charactersIn: "\""))
		self.init(lat: latitude, long: longitude, diseaseName: name, date: date, date_healthy: date_healthy)
	}
	
}
