//
//  ContinueArrow.swift
//  Pratically
//
//  Created by Ryan Bradford on 8/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class ContinueArrow: UIButton {
	
	var holder: IntroHolder!
	
	public init(frame: CGRect, holder: IntroHolder) {
		self.holder = holder
		super.init(frame: frame)
		self.backgroundColor = COLORS.COLOR_3
		self.addTarget(self, action: "next:", for: .touchUpInside)
		self.layer.cornerRadius = 20
		self.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 30)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@objc func next(_ sender: UIButton?) {
		holder.askNext()
	}
}
