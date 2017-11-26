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
	
	init(lat: Double, long: Double, diseaseName: String, date: String, date_healthy: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date_healthy = dateFormatter.date(from: date_healthy)!
        print(String(describing: self.date_healthy))
        
		self.lat = lat
		self.long = long
		self.diseaseName = diseaseName
    
		self.date = dateFormatter.date(from: date)!
	}
	
}
