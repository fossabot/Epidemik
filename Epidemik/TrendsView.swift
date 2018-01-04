//
//  TrendsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 11/8/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class TrendsView: UIScrollView {
	
	var trends = Array<Trend>()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		getAddressInfo()
		self.isScrollEnabled = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func getAddressInfo() {
		let address = FileRW.readFile(fileName: "address.epi")
		
		if (address != nil && address != "") {
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
				if(error != nil) {
				} else if let buffer = placemarks?[0] {
					let location = buffer.location;
					self.getTrends(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
				}
			})
		}
	}
	
	func getTrends(latitude: Double, longitude: Double) {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getTrends.php")!)
		request.httpMethod = "POST"
		let postString = "latitude=" + String(latitude) + "&longitude=" + String(longitude) +
		"&get=hi"
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
			DispatchQueue.main.sync {
				self.processTrends(response: responseString!)
			}
			
		}
		task.resume()
	}
	
	func processTrends(response: String) {
		let indivTrends = response.split { $0 == "\n"}.map(String.init)
		for text in indivTrends {
			let parts = text.split { $0 == ","}.map(String.init)
			let currentTrend = Trend(name: parts[0], weight: Double(parts[1])!, width: Double(self.frame.width))
			trends.append(currentTrend)
		}
		if trends.count == 0 {
			trends.append(Trend(name: Trend.nothing, weight: 0, width: Double(self.frame.width)))
		}
		displayTrends()
	}
	
	func displayTrends() {
		let startShift = self.frame.height / 6
		for i in 0 ..< trends.count {
			let toDisplay = trends[i]
			toDisplay.frame.origin.y = CGFloat(i) * (6.0/5.0*toDisplay.frame.height) + startShift
			self.addSubview(toDisplay)
		}
		if(trends.count > 0) {
			self.contentSize = CGSize(width: self.frame.width, height: (trends.last?.frame.origin.y)! + 2*(trends.last?.frame.height)!)
		}
	}
	
	func updateTrends() {
		for trend in trends {
			trend.removeFromSuperview()
		}
		trends = Array<Trend>()
		getAddressInfo()
	}
	
}
