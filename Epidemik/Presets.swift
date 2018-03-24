//
//  ColorScheme.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/22/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class PRESETS {
	
	public static var RED  = UIColor(displayP3Red: 169/255.0, green: 18/255.0, blue: 27/255.0, alpha: 1) // Dark Red
	public static var GRAY  = UIColor.gray // Gray
	public static var WHITE  = UIColor(displayP3Red: 255.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1) //White
	
	public static var FONT_NAME = "Helvetica"
	public static var BOLD_FONT_NAME = "Helvetica-Bold"
	public static var SCALE = 0.8
	
	public static var FONT_SMALL = UIFont(name: FONT_NAME, size: CGFloat(10*SCALE))
	public static var FONT_MEDIUM = UIFont(name: FONT_NAME, size: CGFloat(15*SCALE))
	public static var FONT_BIG = UIFont(name: FONT_NAME, size: CGFloat(20*SCALE))
	public static var FONT_SMALL_BOLD = UIFont(name: BOLD_FONT_NAME, size: CGFloat(10*SCALE))
	public static var FONT_BIG_BOLD = UIFont(name: BOLD_FONT_NAME, size: CGFloat(20*SCALE))
	
	
}
