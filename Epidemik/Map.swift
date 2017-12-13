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

class Map: MKMapView, MKMapViewDelegate, UIGestureRecognizerDelegate {
	
	var longWidth: Double!
	var latWidth: Double!
	var startLong: Double!
	var startLat: Double!
	
	var mapOverlay: MKOverlay!
	
	var overlayCreator: MapOverlayCreator!
	
	var filterBar: TimeSelector!
	
	var CIRCUMFRENCE_OF_EARTH = 400750000.0 //In Meters
	
	var playButton: UIButton!
	
	var totalOverlays = 0
	var overlaysDraw = 0
	
	// Creates the map view, given a view frame, a lat,long width in meters, and a start lat,long in degrees
	init(frame: CGRect, realLatWidth: Double, realLongWidth: Double, startLong: Double, startLat: Double) {
		super.init(frame: frame)
		self.startLong = startLong
		self.startLat = startLat
		
		latWidth = (Double(realLatWidth) * 360 / (CIRCUMFRENCE_OF_EARTH))
		longWidth = (Double(realLongWidth) * 360 / (CIRCUMFRENCE_OF_EARTH))
		
		initMapPrefs()
		
		initGestureControls()
		
		initTimeSelector()
		
		initPlayButton()
		
		self.isRotateEnabled = false
		
		//self.animateVsTime(start: newDate!, end: Date())
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// Nothing -> Nothing
	// Inits the bar that can be used to selcted the filter date
	func initTimeSelector() {
		let frame = CGRect(x: self.frame.width*3/16, y: self.frame.height/16, width: self.frame.width*5/8, height: self.frame.height/16)
		filterBar = TimeSelector(frame: frame, map: self)
		self.addSubview(filterBar)
	}
	
	// Nothing -> Nothing
	// inits the play button
	func initPlayButton() {
		playButton = UIButton(frame: CGRect(x: self.frame.width*13/16 + self.frame.height/64, y: self.frame.height/16, width: self.frame.height/16, height: self.frame.height/16))
		playButton.backgroundColor = UIColor.clear
		let image = UIImage(named: "play.png")
		playButton.setBackgroundImage(image, for: .normal)
		self.addSubview(playButton)
		
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.animateVsTime(sender:)));
		playButton.addGestureRecognizer(gestureRecognizer)
	}
	
	// Nothing -> Map
	// Uses the MapKit to create the map display
	// As of now, cannot be moved or touched or interacted with
	func initMapPrefs() {
		self.mapType = MKMapType.standard
		self.delegate = self
		let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(39), longitude: CLLocationDegrees(-98))
		let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(120), longitudeDelta: CLLocationDegrees(120)))
		self.setRegion(region, animated: true)
		
		initOverlayCreator()
	}
	
	func initOverlayCreator() {
		let region = self.region
		let latWidth = region.span.latitudeDelta
		let longWidth = region.span.longitudeDelta
		let startLat = region.center.latitude
		let startLong = region.center.longitude
		overlayCreator = MapOverlayCreator(map: self, longWidth: longWidth, latWidth: latWidth, startLong: startLong - longWidth/2, startLat: startLat - latWidth/2)
	}
	
	func updateOverlays() {
		let region = self.region
		let latWidth = region.span.latitudeDelta
		let longWidth = region.span.longitudeDelta
		let startLat = region.center.latitude
		let startLong = region.center.longitude
		overlayCreator = MapOverlayCreator(map: self, longWidth: longWidth, latWidth: latWidth, startLong: startLong - longWidth/2, startLat: startLat - latWidth/2)
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let dataPolygon = overlay as! DiseasePolygon
		
		let polygonView = MKPolygonRenderer(overlay: overlay)
		let power = CGFloat(dataPolygon.intensity / overlayCreator.averageIntensity)
		let color = UIColor(displayP3Red: power*185.0/255.0, green: 35.0/255.0, blue: 58.0/255.0, alpha: power*2.0/4.0)
		polygonView.strokeColor = color
		polygonView.fillColor = color
		overlaysDraw += 1
		if(overlaysDraw == totalOverlays-1) {
			overlayCreator.finishFiltering()
		}
		return polygonView
	}
	
	func initGestureControls() {
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
		// make your class the delegate of the pan gesture
		panGesture.delegate = self
		
		// add the gesture to the mapView
		self.addGestureRecognizer(panGesture)
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	@objc func didDragMap(sender: UIGestureRecognizer!) {
		if sender.state == .ended {
			overlayCreator.updateOverlay()
		}
	}
	
	func filterDate(ratio: Double) {
		let sixMonths = 15770000.0
		let newDate = Date().addingTimeInterval(sixMonths*ratio - sixMonths)
		overlayCreator.filterDate(newDate: newDate)
	}
	
	@objc func animateVsTime(sender:UIGestureRecognizer) {
		let today = Date()
		DispatchQueue.global().async {
			for i in 1 ..< 101 {
				let sixMonths = 15770000.0
				let newDate = today.addingTimeInterval(sixMonths*Double(i)/100.0 - sixMonths)
				DispatchQueue.main.sync {
					self.overlayCreator.filterDate(newDate: newDate)
					self.filterBar.updateBar(ratio: Double(i)/100.0)
				}
				usleep(100000)
			}
		}
	}
	
}
