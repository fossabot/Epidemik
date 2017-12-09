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
		let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
		let url = NSURL(fileURLWithPath: path)
		let filePath = url.appendingPathComponent(fileName)?.path
		let fileManager = FileManager.default
		if !fileManager.fileExists(atPath: filePath!) {
			return nil
		}
		let file = fileName //this is the file. we will write to and read from it
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			
			let path = dir.appendingPathComponent(file)
			
			do {
				let fileText = try String(contentsOf: path, encoding: String.Encoding.utf8)
				return fileText
			}
			catch {/* error handling here */
			}
		}
		return nil
	}
	
	public static func writeFile(fileName: String, contents: String) {
		let file = fileName //this is the file. we will write to and read from it
		
		let text = contents //just a text
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			
			let path = dir.appendingPathComponent(file)
			
			//writing
			do {
				try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
			}
			catch {/* error handling here */}
		}
	}
	
	public static func deleteFile(fileName: String) {
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			
			do {
				try FileManager.default.removeItem(at: dir.appendingPathComponent(fileName))
			} catch {
				
			}
		}
	}
	
	public static func fileExists(fileName: String) -> Bool {
		if FileRW.readFile(fileName: fileName) == nil {
			return false
		}
		return true
	}
	
	
	
}

