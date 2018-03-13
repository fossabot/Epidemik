//
//  PersonalTrendLoadingReactor.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/8/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

class PersonalTrendLoadingReactor: IFunc<Int,Int> {
	
	var pTrendsView: PTrendsView
	
	init(pTrendsView: PTrendsView) {
		self.pTrendsView = pTrendsView
	}
	
	override func apply(t: Int) -> Int? {
		pTrendsView.displayTrends()
		return 1
	}
	
}
