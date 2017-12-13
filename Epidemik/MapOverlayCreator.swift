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
	
	var numXY = 30.0
	
	var latLongDisease: [[DiseasePolygon?]]
	
	var datapoints = Array<Disease>()
	var toUseDatapoints = Array<Disease>()
	
	var RADIUS_OF_EARTH = 6371000.0 //In Meters
	
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
		self.latLongDisease = [[DiseasePolygon]](repeating: [DiseasePolygon](repeating: DiseasePolygon(), count: Int(numXY)), count: Int(numXY))
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
	
	// Combine create and process into one
	// Processes the array, and makes the visual graphic look slightly nicer
	func createOverlays() {
		map.overlaysDraw = 0
		map.removeOverlays(map.overlays)
		latLongDisease = [[DiseasePolygon?]](repeating: [DiseasePolygon?](repeating: nil, count: Int(numXY)), count: Int(numXY))
		var realPointCounts = 1.0
		let intervalLat = latWidth / numXY
		let intervalLong = longWidth / numXY
		for data in toUseDatapoints {
			let deltaLat = data.lat - startLat
			let deltaLong = data.long - startLong
			if deltaLong > 0 && deltaLat > 0 && deltaLat < latWidth && deltaLong < longWidth {
				let posnLat =  Int(floor(deltaLat / (latWidth / numXY)))
				let posnLong = Int(floor(deltaLong / (longWidth / numXY)))
				
				let realLat = (Double(posnLat)*intervalLat+startLat)
				let realLong = (Double(posnLong)*intervalLong+startLong)
				let scale = latWidth / numXY
				var points=[CLLocationCoordinate2DMake(realLat,  realLong),CLLocationCoordinate2DMake(realLat+scale,  realLong),CLLocationCoordinate2DMake(realLat+scale,  realLong+scale),CLLocationCoordinate2DMake(realLat,  realLong+scale)]
				if posnLat >= latLongDisease.count || posnLong >= latLongDisease[posnLat].count {
					continue
				}
				
				if latLongDisease[posnLat][posnLong] == nil {
					latLongDisease[posnLat][posnLong] = DiseasePolygon(coordinates: &points, count: points.count)
					averageIntensity += latLongDisease[posnLat][posnLong]!.intensity
					realPointCounts += 1
				}
				averageIntensity += 1
				latLongDisease[posnLat][posnLong]!.intensity += 1
			}
		}
		
		averageIntensity /= realPointCounts
		map.totalOverlays = Int(realPointCounts)
		
		if(map.totalOverlays == 1) {
			finishFiltering()
			return
		}
		
		let _ = latLongDisease.map {
			$0.map {
				if($0 != nil && $0!.intensity > 0.1) {
					if $0 != nil {
						map.add($0!)
					}
				}
			}
		}
	}
	
	func finishFiltering() {
		if(toFilter.count > 0) {
			toFilter.remove(at: 0)
		}
		filtering = false
	}
	
	// Processes the text from the server and loads it to a local array
	func loadTextToArray() {
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
		self.toUseDatapoints = datapoints.filter({
			($0.date_healthy > filterDate && $0.date < filterDate)
		})
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
			self.createOverlays()
		}
	}
	
	func filterDates() {
		DispatchQueue.global().async {
			while self.toFilter.count > 0 {
				if(!self.filtering) {
					self.filtering = true
					self.filterDate = self.toFilter.first!
					self.toUseDatapoints = self.datapoints.filter({
						($0.date_healthy > self.filterDate && $0.date < self.filterDate)
					})
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
