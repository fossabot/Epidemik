//
//  TrendLoadingReactor.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/19/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

class GlobalTrendLoadingReactor: IFunc<Int,Int> {
	
	var trendsView: GTrendsView
	
	init(trendsView: GTrendsView) {
		self.trendsView = trendsView
	}
	
	override func apply(t: Int) -> Int? {
		trendsView.removeAllCurrentTrends()
		trendsView.displayTrends()
		return 1
	}
}

