//
//  MapOverlay.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/30/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public class MapOverlayCreator {
	
	var startLong: Double!
	var startLat: Double!
	
	var latWidth: Double!
	var longWidth: Double!
	
	var datapoints = Array<Disease>()
	
	var toDraw = ""
	
	var map: Map!
	
	var averageIntensity: Double = 1.0
	
	var filterDate = Date()
	
	var minLat: Double!
	var minLong: Double!
	
	var maxLat: Double!
	var maxLong: Double!
	
	init(map: Map, longWidth: Double, latWidth: Double, startLong: Double, startLat: Double) {
		self.startLat = startLat
		self.startLong = startLong
		
		self.minLat = startLat
		self.minLong = startLong
		
		self.maxLat = latWidth + startLat
		self.maxLong = longWidth + startLong
		
		self.latWidth = latWidth
		self.longWidth = longWidth
		
		self.map = map
		getArray()
	}
	
	func createOverlays() {
		removeOverlaysFromMap()
		if(datapoints.count == 0) {
			return
		}
		addOverlaysToMap()
	}
	
	func removeOverlaysFromMap() {
		for overlay in map.overlays {
			map.remove(overlay)
		}
	}
	
	func addOverlaysToMap() {
		for stuff in datapoints {
			map.add(stuff)
		}
	}
	
	func getGoodRadius() -> Double {
		return 800.0
	}
	
	
	// Processes the text from the server and loads it to a local array
	func loadTextToArray() {
		let goodRad = self.getGoodRadius()
		let latArray = toDraw.split(separator: "\n")
		for lat in 0 ..< latArray.count {
			let longArray = latArray[lat].split(separator: ",")
			let latitude = (Double(longArray[0])!)
			let longitude = (Double(longArray[1])!)
			let name = String(longArray[2])
			let date = String(longArray[3])
			var date_healthy = String(longArray[4])
			date_healthy = date_healthy.trimmingCharacters(in: CharacterSet.init(charactersIn: "\""))
			let newDisease = Disease(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: goodRad)
			newDisease.setValues(diseaseName: name, date: date, date_healthy: date_healthy, intensity: 1.0)
			self.datapoints.append(newDisease)
		}
	}
	
	// Loads the text from the server given a lat, long, lat width, long height
	// Calls the text->array, process, and draw
	public func getArray() {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getCurrentData.php")!)
		request.httpMethod = "POST"
		let postString = ""
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
			self.toDraw += responseString!
			DispatchQueue.main.sync {
				self.loadTextToArray()
				self.createOverlays()
			}
		}
		task.resume()
	}
	
	func filterDate(newDate: Date) { //Need to make way more efficient
		self.filterDate = newDate
		for renderer in map.overlayRenderers {
			renderer.setNeedsDisplay()
		}
	}
	
}
