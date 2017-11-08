//
//  ButtonSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/29/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class ButtonSelector: UIView {
	
	var buttons = Array<ButtonExtension>()
	var currentSelected = 0
	public var selectorImage = UIImage(named: "checked")
	var selectorFrame: UIView!
	
	public init(frame: CGRect, items: Array<String>) {
		super.init(frame: frame)
		initSelector(items: items)
		initButtons(items: items)
	}
	
	@objc func buttonPressed(_ sender: UIButton?) {
		self.currentSelected = (sender as! ButtonExtension).ID
		UIView.animate(withDuration: 0.1, animations: {
			self.selectorFrame.frame = CGRect(x: (sender?.frame.origin.x)!, y: 0, width: self.selectorFrame.frame.width, height: self.selectorFrame.frame.height)
		})
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initSelector(items: Array<String>) {
		selectorFrame = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width/CGFloat(items.count), height: self.frame.height))
		selectorFrame.backgroundColor = UIColor.green
		self.addSubview(selectorFrame)
	}
	
	func initButtons(items: Array<String>) {
		var baseFrame = CGRect(x: 0, y: 0, width: self.frame.width/CGFloat(items.count), height: self.frame.height)
		var id = 0
		for item in items {
			let currentButton = ButtonExtension(frame: baseFrame)
			currentButton.ID = id
			currentButton.addTarget(self, action: #selector(ButtonSelector.buttonPressed(_:)), for: .touchUpInside)
			currentButton.setTitle(item, for: UIControlState.normal)
			buttons.append(currentButton)
			baseFrame.origin.x += self.frame.width/CGFloat(items.count)
			self.addSubview(buttons.last!)
			id += 1
		}
	}
	
	func getSelected() -> Int {
		return currentSelected
	}
	
	
	
}
