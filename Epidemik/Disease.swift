//
//  Disease.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/11/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import MapKit

public class Disease: MKCircle {
	
	var diseaseName: String?
	var date: Date?
	var date_healthy: Date?
	
	var intensity = 0.0
	static var latConversionNumber = 110575.0
	static var longConversionNumber = 111303.0
	
	func setValues(diseaseName: String, date: String, date_healthy: String, intensity: Double) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		self.date_healthy = dateFormatter.date(from: date_healthy)!
		self.date = dateFormatter.date(from: date)!

		self.diseaseName = diseaseName
		
		self.intensity = intensity
	}
	
	func setValues(diseaseName: String, date_sick: Date, date_healthy: Date, intensity: Double) {
		self.date_healthy = date_healthy
		self.date = date_sick
		
		self.diseaseName = diseaseName
		
		self.intensity = intensity
	}
	
	func touchesOther(toTest: Disease) -> Bool {
		let distanceBetween = distanceTo(toTest: toTest)
		return distanceBetween <= (self.radius + toTest.radius)
	}
	
	func distanceTo(toTest: Disease) -> Double {
		let latSq = pow(Disease.latConversionNumber*self.coordinate.latitude - Disease.latConversionNumber*toTest.coordinate.latitude, 2)
		let longSq = pow(Disease.longConversionNumber*self.coordinate.longitude - Disease.longConversionNumber*toTest.coordinate.longitude, 2)
		let hyp = sqrt(latSq + longSq)
		return hyp
	}
	
	func averageCenter(toUse: Disease) -> CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: (self.coordinate.latitude + toUse.coordinate.latitude)/2, longitude: (self.coordinate.longitude + toUse.coordinate.longitude)/2)
	}
	
}
