//
//  FileRW.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/24/17
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation

public class FileRW {
	
	public static func readFile(fileName: String) -> String? {
		let defaults = UserDefaults(suiteName: "group.io.thaumavor.rbradford.Epidemik")
		return defaults?.object(forKey: fileName) as? String
	}
	
	public static func writeFile(fileName: String, contents: String) {
		let defaults = UserDefaults(suiteName: "group.io.thaumavor.rbradford.Epidemik")
		defaults?.set(contents, forKey: fileName)
	}
	
	public static func deleteFile(fileName: String) {
		let defaults = UserDefaults(suiteName: "group.io.thaumavor.rbradford.Epidemik")
		defaults?.removeObject(forKey: fileName)
	}
	
	public static func fileExists(fileName: String) -> Bool {
		if FileRW.readFile(fileName: fileName) == nil {
			return false
		}
		return true
	}
	
}

