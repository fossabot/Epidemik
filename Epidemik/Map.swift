//
//  Map.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/1/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class Map: UIView, MKMapViewDelegate, UIGestureRecognizerDelegate {
	
	var longWidth: Double!
	var latWidth: Double!
	var startLong: Double!
	var startLat: Double!
	
	var mapView: MKMapView!
	var mapOverlay: MKOverlay!
	
	var overlayCreator: MapOverlayCreator!
	
	var CIRCUMFRENCE_OF_EARTH = 400750000.0 //In Meters
	
	// Creates the map view, given a view frame, a lat,long width in meters, and a start lat,long in degrees
	init(frame: CGRect, realLatWidth: Double, realLongWidth: Double, startLong: Double, startLat: Double) {
		super.init(frame: frame)
		self.startLong = startLong
		self.startLat = startLat
		
		latWidth = (Double(realLatWidth) * 360 / (CIRCUMFRENCE_OF_EARTH))
		longWidth = (Double(realLongWidth) * 360 / (CIRCUMFRENCE_OF_EARTH))
		
		initMap()
		
		initGestureControls()
		//self.animateVsTime(start: newDate!, end: Date())
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// Nothing -> Map
	// Uses the MapKit to create the map display
	// As of now, cannot be moved or touched or interacted with
	func initMap() {
		mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		mapView.mapType = MKMapType.mutedStandard
		mapView.delegate = self
		let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(39), longitude: CLLocationDegrees(-98))
		let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(120), longitudeDelta: CLLocationDegrees(120)))
		mapView.setRegion(region, animated: true)
		self.addSubview(mapView)
		
		initOverlayCreator()
	}
	
	func initOverlayCreator() {
		let region = mapView.region
		let latWidth = region.span.latitudeDelta
		let longWidth = region.span.longitudeDelta
		let startLat = region.center.latitude
		let startLong = region.center.longitude
		overlayCreator = MapOverlayCreator(map: self.mapView, longWidth: longWidth, latWidth: latWidth, startLong: startLong - longWidth/2, startLat: startLat - latWidth/2)
	}
	
	func updateOverlays() {
		let region = mapView.region
		let latWidth = region.span.latitudeDelta
		let longWidth = region.span.longitudeDelta
		let startLat = region.center.latitude
		let startLong = region.center.longitude
		overlayCreator = MapOverlayCreator(map: self.mapView, longWidth: longWidth, latWidth: latWidth, startLong: startLong - longWidth/2, startLat: startLat - latWidth/2)
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let dataPolygon = overlay as! DiseasePolygon
		
		let polygonView = MKPolygonRenderer(overlay: overlay)
		let power = CGFloat(dataPolygon.intensity / overlayCreator.averageIntensity)
		let color = UIColor(displayP3Red: power*185.0/255.0, green: 35.0/255.0, blue: 58.0/255.0, alpha: power)
		polygonView.strokeColor = color
		polygonView.fillColor = color
		return polygonView
	}
	
	func initGestureControls() {
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
		// make your class the delegate of the pan gesture
		panGesture.delegate = self
		
		// add the gesture to the mapView
		mapView.addGestureRecognizer(panGesture)
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	@objc func didDragMap(_ sender: UIGestureRecognizer) {
		if sender.state == .ended {
			overlayCreator.updateOverlay()
		}
	}
	
	func animateVsTime(start: Date, end: Date) {
		var currentDate = start
		DispatchQueue.global().async {
			while(currentDate < end) {
				self.overlayCreator.filterDate(date: currentDate)
				self.overlayCreator.processArray()
				DispatchQueue.global().sync {
					self.overlayCreator.createOverlays()
				}
				currentDate += (end.timeIntervalSinceNow - start.timeIntervalSinceNow) / 1000
				usleep(10000)
			}
		}
	}
}
