//
//  TrendDataCenter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/19/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import CoreLocation

class TrendDataCenter {
	
	var trends = Array<Trend>()
	var reactor: TrendLoadingReactor
	
	init(reactor: TrendLoadingReactor) {
		self.reactor = reactor
		loadData()
	}
	
	func getTrends() -> Array<Trend> {
		return self.trends
	}
	
	func loadData() {
		self.trends = Array<Trend>()
		let username = FileRW.readFile(fileName: "username.epi")
		self.getTrends(username: username!)
	}
	
	func getTrends(username: String) {
		var request = URLRequest(url: URL(string: "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getTrends.php")!)
		request.httpMethod = "POST"
		let postString = "username=" + String(username) + "&get=hi"
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
			let currentTrend = Trend(name: parts[0], weight: Double(parts[1])!)
			trends.append(currentTrend)
		}
		if trends.count == 0 {
			trends.append(Trend(name: Trend.nothing, weight: 0))
		}
		reactor.apply(t: 1)
	}
	
}
