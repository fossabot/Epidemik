//
//  DataLoadingReactor.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/17/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

class DiseaseLoadingReactor: IFunc<Int,Int> {
	
	var map: Map
	
	init(map: Map) {
		self.map = map
	}
	
	override func apply(t: Int) -> Int? {
		map.initAfterData()
		return 1
	}
}
