//
//  DiseaseQuestions.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/24/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

public class DISEASE_QUESTIONS {

	public static var COMMON_COLD_QUESTIONS = ["I have a runny nose", "I have a minor fever", "My eyes are watering", "I am sneezing a lot", "I have a headache"]
	public static var FLU_QUESTIONS = ["I have a chills", "I have a fever", "I am fatigued", "I am congested", "I'm sneezing alot"]
	public static var GAST_QUESTIONS = ["I have vomited today", "I have diarrhea", "I am nauseous", "I have cramps", "I have a fever"]
	public static var STAPH_QUESTIONS = ["I have swelling", "I am feeling very itchy", "I have a rash", "I have a fever", "I have blisters"]
	public static var STREP_QUESTIONS = ["I have a sore throat", "I have swelling", "I have a fever", "I am aching all over", "I have a headache"]
	public static var LYME_QUESTIONS = ["There's a bull's eye rash on my body", "I have a fever", "I have a headache", "I am feeling tired", "I am very stiff"]
	public static var TEB_QUESTIONS = ["I have a cough", "I am sweating at night", "I have chills", "I am very tired", "I am not hungry"]
	public static var PINK_QUESTIONS = ["My eyes are itchy", "My eyes are watering", "My eyes are red", "I have discharge", "My eyes are swelling"]
	public static var HAND_QUESTIONS = ["I have rashes", "I have blisters", "I am coughing", "I have a headache", "I have mouth sores"]

	public static func getDiseaseQuestions(diseaseName: String) -> Array<String> {
		if(diseaseName == "Influenza (Flu)") {
			return FLU_QUESTIONS
		} else if(diseaseName == "Gastroenteritis (Stomach Flu)") {
			return GAST_QUESTIONS
		} else if(diseaseName == "Staph Infection") {
			return STAPH_QUESTIONS
		} else if(diseaseName == "Strep Throat") {
			return STREP_QUESTIONS
		} else if(diseaseName == "Common Cold") {
			return COMMON_COLD_QUESTIONS
		} else if(diseaseName == "Lyme Disease") {
			return LYME_QUESTIONS
		} else if(diseaseName == "Tuberculosis") {
			return TEB_QUESTIONS
		} else if(diseaseName == "Pink Eye") {
			return PINK_QUESTIONS
		} else if(diseaseName == "Hand Foot and Mouth") {
			return HAND_QUESTIONS
		} else {
			return COMMON_COLD_QUESTIONS
		}
	}
}
