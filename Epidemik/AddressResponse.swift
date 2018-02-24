//
//  AddressResponse.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/23/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

class AddressResponse: IFunc<String, Int> {
	
	override func apply(t: String) -> Int {
		ADDRESS.convertToCordinates(address: t)
		return 1
	}
	
}
