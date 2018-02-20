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
	
	var dataCenter: DataCenter!
	
	init(map: Map, longWidth: Double, latWidth: Double, startLong: Double, startLat: Double, dataCenter: DataCenter) {
		self.latLongDisease = [[DiseasePolygon]](repeating: [DiseasePolygon](repeating: DiseasePolygon(), count: Int(numXY)), count: Int(numXY))
		self.dataCenter = dataCenter
		self.startLat = startLat
		self.startLong = startLong
		
		self.minLat = startLat
		self.minLong = startLong
		
		self.maxLat = latWidth + startLat
		self.maxLong = longWidth + startLong
		
		self.latWidth = latWidth
		self.longWidth = longWidth
		
		self.map = map
		
		self.createOverlays(date: Date())
	}
	
	// Combine create and process into one
	// Processes the array, and makes the visual graphic look slightly nicer
	func createOverlays(date: Date) {
		map.overlaysDraw = 0
		map.removeOverlays(map.overlays)
		latLongDisease = [[DiseasePolygon?]](repeating: [DiseasePolygon?](repeating: nil, count: Int(numXY)), count: Int(numXY))
		var realPointCounts = 1.0
		let intervalLat = latWidth / numXY
		let intervalLong = longWidth / numXY
		let toUse = dataCenter.getDiseaseData(date: date)
		for data in toUse {
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
					map.add($0!)
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
	
	
	func updateOverlay() {
		let latWidth = map.region.span.latitudeDelta*2
		let longWidth = map.region.span.longitudeDelta*2
		let newStartLat = map.region.center.latitude - latWidth/2
		let newStartLong = map.region.center.longitude - longWidth/2
		
		self.startLat = newStartLat
		self.startLong = newStartLong
		self.latWidth = latWidth
		self.longWidth = longWidth
		
		self.createOverlays(date: Date())
	}
	
	func filterDates() {
		DispatchQueue.global().async {
			while self.toFilter.count > 0 {
				if(!self.filtering) {
					self.filtering = true
					DispatchQueue.main.sync {
						self.createOverlays(date:self.filterDate)
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
