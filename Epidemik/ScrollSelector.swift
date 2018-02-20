//
//  ScrollSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/29/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation

import Foundation
import UIKit

public class ScrollSelector: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
	
	var delayPicker: UIPickerView!
	var items: Array<String>?
	var allItems: Array<String>!
	var timeTextField: UITextField?
	
	init(frame: CGRect, items: Array<String>) {
		super.init(frame: frame)
		
		self.items = items
		self.allItems = items
		
		delayPicker = UIPickerView()
		delayPicker.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
		
		timeTextField = UITextField()
		timeTextField?.font = UIFont(name: "Helvetica-Bold", size: 20)
		
		delayPicker?.dataSource = self
		delayPicker?.delegate = self
		
		timeTextField?.inputView = delayPicker
		timeTextField?.text = items[0]
		
		self.addSubview(delayPicker)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return items![row]
	}
	
	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if items != nil && row < items!.count {
			timeTextField?.text = self.items![row]
		}
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return items!.count
	}
	
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	public func limitItems(search: String) {
		if(search != "") {
			items = allItems.filter({ (toTest) -> Bool in
				(toTest.contains(search))
			})
		} else {
			items = allItems
		}
		delayPicker?.dataSource = self
		delayPicker?.delegate = self
		delayPicker.updateFocusIfNeeded()
	}
}

