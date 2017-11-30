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
    
    var numXY = 50.0
    
	var latLongDisease: [[Double]]
    
    var datapoints = Array<Disease>()
    var toUseDatapoints = Array<Disease>()
    
    var RADIUS_OF_EARTH = 6371000.0 //In Meters
    
    var toDraw: String?
    
    var map: MKMapView!
    
    var averageIntensity: Double = 1.0
	
	var filterDate = Date()
    
    init(map: MKMapView, longWidth: Double, latWidth: Double, startLong: Double, startLat: Double) {
		self.latLongDisease = [[Double]](repeating: [Double](repeating: 0.0, count: Int(numXY)), count: Int(numXY))
        self.startLat = startLat
        self.startLong = startLong
        self.latWidth = latWidth
        self.longWidth = longWidth
        self.map = map
        getArray(latitude: (startLat), longitude: (startLong),
                 rangeLong: (longWidth), rangeLat: (latWidth))
    }
    
    // Draws the given data loaded to the array from the server
    func createOverlays() {
        averageIntensity = Double(toUseDatapoints.count)
        var realPointCounts = 1.0
        map.removeOverlays(map.overlays)
        let intervalLat = latWidth / numXY
        let intervalLong = longWidth / numXY
		
		var newPolys = [DiseasePolygon]()
		
        for lat in 0 ..< latLongDisease.count {
            for long in 0 ..< latLongDisease[lat].count {
                if((latLongDisease[lat][long]) > 0.2) {
                    let realLat = (Double(lat)*intervalLat+startLat)
                    let realLong = (Double(long)*intervalLong+startLong)
                    let scale = latWidth / numXY
                    var points=[CLLocationCoordinate2DMake(realLat,  realLong),CLLocationCoordinate2DMake(realLat+scale,  realLong),CLLocationCoordinate2DMake(realLat+scale,  realLong+scale),CLLocationCoordinate2DMake(realLat,  realLong+scale)]
                    
                    let polygon = DiseasePolygon(coordinates: &points, count: points.count)
                    polygon.intensity = (latLongDisease[lat][long])
					realPointCounts += 1
                    newPolys.append(polygon)
                }
            }
        }
		averageIntensity /= realPointCounts

		newPolys.map {
			map.add($0)
		}
	}
    
    // Processes the text from the server and loads it to a local array
    func loadTextToArray() {
        let latArray = toDraw!.characters.split { $0 == "\n"}.map(String.init)
        for lat in 0 ..< latArray.count {
            let longArray = latArray[lat].characters.split { $0 == ","}.map(String.init)
            let latitude = (Double(longArray[0])!)
            let longitude = (Double(longArray[1])!)
            let name = (longArray[2])
            let date = (longArray[3])
            var date_healthy = longArray[4]
            date_healthy = date_healthy.trimmingCharacters(in: CharacterSet.init(charactersIn: "\""))
            let newDisease = Disease(lat: latitude, long: longitude, diseaseName: name, date: date, date_healthy: date_healthy)
            self.datapoints.append(newDisease)
        }
        self.toUseDatapoints = datapoints.filter({
            ($0.date_healthy > filterDate && $0.date < filterDate)
        })
    }
    
    // Processes the array, and makes the visual graphic look slightly nicer
    func processArray() {
        latLongDisease = [[Double]](repeating: [Double](repeating: 0.0, count: Int(numXY)), count: Int(numXY))
        for data in toUseDatapoints {
            let deltaLat = data.lat - startLat
            let deltaLong = data.long - startLong
            if deltaLong > 0 && deltaLat > 0 && deltaLat < latWidth && deltaLong < longWidth {
                let posnLat =  Int(floor(deltaLat / (latWidth / numXY)))
                let posnLong = Int(floor(deltaLong / (longWidth / numXY)))
                latLongDisease[posnLat][posnLong] += 1
            }
        }
    }
    
    // Loads the text from the server given a lat, long, lat width, long height
    // Calls the text->array, process, and draw
    public func getArray(latitude: Double, longitude: Double, rangeLong: Double, rangeLat: Double) {
        var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getCurrentData.php")!)
        request.httpMethod = "POST"
        let postString = "latitude=" + String(latitude) + "&longitude=" + String(longitude) +
            "&rangeLong=" + String(rangeLong) + "&rangeLat=" + String(rangeLong)
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
            self.toDraw = responseString!
            DispatchQueue.main.sync {
                self.loadTextToArray()
                self.processArray()
                self.createOverlays()
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
        datapoints = [Disease]()
        getArray(latitude: newStartLat, longitude: newStartLong, rangeLong: longWidth, rangeLat: latWidth)
    }
	
	func filterDate(newDate: Date) { //Need to make way more efficient
		self.filterDate = newDate
		self.toUseDatapoints = datapoints.filter({
			($0.date_healthy > filterDate && $0.date < filterDate)
		})
		self.processArray()
		self.createOverlays()
	}
}
