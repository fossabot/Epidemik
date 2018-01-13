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
	var toUseDatapoints = Array<Disease>()
	
	var toDrawDatapoints = Array<Disease>()
	
	var toDraw = ""
	
	var map: Map!
	
	var averageIntensity: Double = 1.0
	
	var filterDate = Date()
	
	var minLat: Double!
	var minLong: Double!
	
	var maxLat: Double!
	var maxLong: Double!
	
	var toFilter = Array<Date>()
	
	var filtering = false
	
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
		getArray(dataRange: [[startLat, startLong, longWidth, latWidth]])
	}
	
	func createOverlays() {
		filterOverlays()
		removeOverlaysFromMap()
		resizeOverlays()
		if(toUseDatapoints.count == 0) {
			print("returning")
			return
		}
		combineOverlays()
		addOverlaysToMap()
	}
	
	func filterOverlays() {
		self.toUseDatapoints = datapoints.filter({
			($0.date_healthy! > filterDate && $0.date! < filterDate && fitsOnScreen(toTest: $0))
		})
	}
	
	func removeOverlaysFromMap() {
		for overlay in map.overlays {
			map.remove(overlay)
		}
	}
	
	func resizeOverlays() {
		toDrawDatapoints = toUseDatapoints
		for var x in 0 ..< toDrawDatapoints.count {
			let center = toDrawDatapoints[x].coordinate
			let newRad = min(toDrawDatapoints[x].intensity * getGoodRadius(), 1000)
			let intensity = toDrawDatapoints[x].intensity
			toDrawDatapoints[x] = Disease(center: center, radius: newRad)
			toDrawDatapoints[x].intensity = intensity
		}
	}
	
	func combineOverlays() {
		for var x in 0 ..< toDrawDatapoints.count-1 {
			var y = x+1
			while(y < toDrawDatapoints.count) {
				if toDrawDatapoints[x].touchesOther(toTest: toDrawDatapoints[y]) {
					let newCenter = toDrawDatapoints[x].averageCenter(toUse: toDrawDatapoints[y])
					let newRadius = toDrawDatapoints[x].radius + toDrawDatapoints[y].radius + toDrawDatapoints[x].distanceTo(toTest: toDrawDatapoints[y])
					let disease_name = toDrawDatapoints[x].diseaseName
					let date_sick = toDrawDatapoints[x].date
					let date_healthy = toDrawDatapoints[x].date_healthy
					let newIntensity = toDrawDatapoints[x].intensity + toDrawDatapoints[y].intensity
					toDrawDatapoints[x] = Disease(center: newCenter, radius: newRadius)
					toDrawDatapoints[x].setValues(diseaseName: disease_name!, date_sick: date_sick!, date_healthy: date_healthy!, intensity: newIntensity)
					toDrawDatapoints.remove(at: y)
					y = x
				}
				y = y + 1
			}
		}
	}
	
	func addOverlaysToMap() {
		let totalIntensity = toUseDatapoints.count
		self.averageIntensity = Double(totalIntensity / toUseDatapoints.count)
		for stuff in toUseDatapoints {
			map.add(stuff)
		}
	}
	
	func getGoodRadius() -> Double {
		return 800.0
	}
	
	
	func finishFiltering() {
		if(toFilter.count > 0) {
			toFilter.remove(at: 0)
		}
		filtering = false
	}
	
	func fitsOnScreen(toTest: Disease) -> Bool {
		let center = toTest.coordinate
		let fits = center.latitude > startLat && center.latitude < startLat+latWidth &&
			center.longitude > startLong && center.longitude < startLong + longWidth
		return fits
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
	public func getArray(dataRange: [[Double]]) {
		var allData = dataRange
		let currentData = dataRange.first
		let latitude = currentData![0]
		let longitude = currentData![1]
		let rangeLong = currentData![2]
		let rangeLat = currentData![3]
		allData.remove(at: 0)
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
			self.toDraw += responseString!
			if allData.count == 0 {
				DispatchQueue.main.sync {
					self.loadTextToArray()
					self.createOverlays()
				}
			} else {
				self.getArray(dataRange: allData)
			}
		}
		task.resume()
	}
	
	
	func updateOverlay() {
		let latWidth = map.region.span.latitudeDelta*2
		let longWidth = map.region.span.longitudeDelta*2
		let newStartLat = map.region.center.latitude - latWidth/2
		let newStartLong = map.region.center.longitude - longWidth/2
		
		self.startLat = newStartLat
		self.startLong = newStartLong
		self.latWidth = latWidth
		self.longWidth = longWidth
		
		var newMinLat = startLat!
		if newMinLat > minLat {
			newMinLat = minLat
		}
		var newMinLong = startLong!
		if newMinLong > minLong {
			newMinLong = minLong
		}
		var newMaxLat = startLat + latWidth
		if newMaxLat < maxLat {
			newMaxLat = maxLat
		}
		var newMaxLong = startLong + longWidth
		if newMaxLong < maxLong {
			newMaxLong = maxLong
		}
		
		var toGet = [[Double]]()
		
		if newMinLat < minLat {
			let longWidth = maxLong - minLong
			let longCord = minLong
			
			let latWidth = minLat - newMinLat
			let latCord = newMinLat
			toGet.append([latCord, longCord!, longWidth, latWidth])
		}
		if newMinLong < minLong {
			let longWidth = minLong - newMinLong
			let longCord = newMinLong
			
			let latWidth = newMaxLat - newMinLat
			let latCord = newMinLat
			toGet.append([latCord, longCord, longWidth, latWidth])
			
		}
		if newMaxLat > maxLat {
			let longWidth = maxLong - minLong
			let longCord = startLong
			
			let latWidth = newMaxLat - maxLat
			let latCord = maxLat
			toGet.append([latCord!, longCord!, longWidth, latWidth])
		}
		if newMaxLong > maxLong {
			let longWidth = newMaxLong - maxLong
			let longCord = maxLong
			
			let latWidth = newMaxLat - newMinLat
			let latCord = newMinLat
			toGet.append([latCord, longCord!, longWidth, latWidth])
		}
		self.minLat = newMinLat
		self.minLong = newMinLong
		self.maxLat = newMaxLat
		self.maxLong = newMaxLong
		self.toDraw = ""
		if toGet.count > 0 {
			getArray(dataRange: toGet)
		} else {
			//self.createOverlays()
		}
	}
	
	func filterDates() {
		DispatchQueue.global().async {
			while self.toFilter.count > 0 {
				if(!self.filtering) {
					self.filtering = true
					self.filterDate = self.toFilter.first!
					DispatchQueue.main.sync {
						self.createOverlays()
					}
				} else {
					usleep(5000)
				}
			}
		}
	}
	
	func filterDate(newDate: Date) { //Need to make way more efficient
		toFilter.append(newDate)
		if toFilter.count == 1 {
			filterDates()
		}
	}
	
}
