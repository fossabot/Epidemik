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
	
	var minLat: Double!
	var minLong: Double!
	
	var maxLat: Double!
	var maxLong: Double!
	
	var dataCenter: DataCenter!
	
	var filterDate = Date()
	
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
		for var overlay in map.overlays {
			map.remove(overlay)
		}
		latLongDisease = [[DiseasePolygon?]](repeating: [DiseasePolygon?](repeating: nil, count: Int(numXY)), count: Int(numXY))
		var realPointCounts = 1.0
		let intervalLat = latWidth / numXY
		let intervalLong = longWidth / numXY
		let toUse = dataCenter.getDiseaseData(date: date)
		var counter = 0
		for data in toUse {
			counter += 1
			let deltaLat = data.lat - startLat
			let deltaLong = data.long - startLong
			if deltaLong > 0 && deltaLat > 0 && deltaLat < latWidth && deltaLong < longWidth {
				let posnLat =  Int(floor(deltaLat / (latWidth / numXY)))
				let posnLong = Int(floor(deltaLong / (longWidth / numXY)))
				
				let realLat = (Double(posnLat)*intervalLat+startLat)
				let realLong = (Double(posnLong)*intervalLong+startLong)
				let scaleLat = latWidth / numXY
				let scaleLong = longWidth / numXY
				var points=[CLLocationCoordinate2DMake(realLat,  realLong),CLLocationCoordinate2DMake(realLat+scaleLat,  realLong),CLLocationCoordinate2DMake(realLat+scaleLat,  realLong+scaleLong),CLLocationCoordinate2DMake(realLat,  realLong+scaleLong)]
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
		let _ = latLongDisease.map {
			$0.map {
				if($0 != nil && $0!.intensity > 0.1) {
					map.add($0!)
				}
			}
		}
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
		
		self.createOverlays(date: self.filterDate)
	}
	
	func filterDate(toFilter: Date) {
		DispatchQueue.global().async {
			self.filterDate = toFilter
			self.createOverlays(date:toFilter)
		}
	}
	
}
