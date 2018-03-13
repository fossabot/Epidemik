//
//  DataCenter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/17/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

public class DataCenter {
	
	var diseaseData: DiseaseDataCenter
	var diseaseReactor: DiseaseLoadingReactor
	
	var globalTrendData: GlobalTrendDataCenter
	var globalTrendReactor: GlobalTrendLoadingReactor
	
	var personalTrendData: PersonalTrendDataCenter
	var personalTrendReactor: PersonalTrendLoadingReactor
	
	var statusData: StatusDataCenter
	
	init(diseaseReactor: DiseaseLoadingReactor, trendReactor: GlobalTrendLoadingReactor, personalTrendReactor: PersonalTrendLoadingReactor, sicknessScreen: SicknessScreen) {
		self.diseaseReactor = diseaseReactor
		self.diseaseData = DiseaseDataCenter(loadingReactor: self.diseaseReactor)
		
		self.globalTrendReactor = trendReactor
		self.globalTrendData = GlobalTrendDataCenter(reactor: self.globalTrendReactor)
		
		self.personalTrendReactor = personalTrendReactor
		self.personalTrendData = PersonalTrendDataCenter(loadingReactor: personalTrendReactor)
		
		statusData = StatusDataCenter(sicknessScreen: sicknessScreen)
		
		self.loadData()
	}
	
	func loadData() {
		loadDiseaseData()
		loadTrendData()
		loadPersonalTrendData()
		loadStatusData()
	}
	
	func loadDiseaseData() {
		diseaseData.loadDiseasePointData()
	}
	
	func getDiseaseData(date: Date) -> Array<Disease> {
		return diseaseData.getAppropriateData(date:date)
	}
	
	func getTrendData() -> Array<Trend> {
		return globalTrendData.getTrends()
	}
	
	func loadTrendData() {
		self.globalTrendData.loadData()
	}
	
	func loadPersonalTrendData() {
		self.personalTrendData.loadData()
	}
	
	func loadStatusData() {
		self.statusData.getUserStatus()
	}

	
}
