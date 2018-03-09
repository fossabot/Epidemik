//
//  DataCenter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/17/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

public class DataCenter {
	
	var diseasePoint: DiseaseDataCenter
	var diseaseReactor: DiseaseLoadingReactor
	
	var trendPoint: TrendDataCenter
	var trendReactor: TrendLoadingReactor
	
	init(diseaseReactor: DiseaseLoadingReactor, trendReactor: TrendLoadingReactor) {
		self.diseaseReactor = diseaseReactor
		self.diseasePoint = DiseaseDataCenter(loadingReactor: self.diseaseReactor)
		
		self.trendReactor = trendReactor
		self.trendPoint = TrendDataCenter(reactor: self.trendReactor)
	}
	
	func loadData() {
		loadDiseaseData()
		loadTrendData()
	}
	
	func loadDiseaseData() {
		diseasePoint.loadDiseasePointData()
	}
	
	func getDiseaseData(date: Date) -> Array<Disease> {
		return diseasePoint.getAppropriateData(date:date)
	}
	
	func getTrendData() -> Array<Trend> {
		return trendPoint.getTrends()
	}
	
	func loadTrendData() {
		self.trendPoint.loadData()
	}
	
	func loadOtherData() {
		
	}
	
}
