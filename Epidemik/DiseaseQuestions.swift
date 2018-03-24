//
//  DiseaseQuestions.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/24/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

public class DISEASE_QUESTIONS {

public static var COMMON_COLD_QUESTIONS = ["I have a fever", "I threw up today", "My eyes are pink", "I feel sick", "My skin hurts"]

	public static func getDiseaseQuestions(diseaseName: String) -> Array<String> {
		return COMMON_COLD_QUESTIONS
	}
}
