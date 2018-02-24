//
//  Asker.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/23/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class Asker {
	
	public static func ask(title: String, placeHolder: String, message: String, isSecure: Bool, resp: IFunc<String,Int>) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
			let textf1 = alert.textFields![0] as UITextField
			resp.apply(t: textf1.text!)
		}))
		alert.addTextField(configurationHandler: {(textField: UITextField) in
			textField.placeholder = placeHolder
			textField.isSecureTextEntry = isSecure
		})
		UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
	}
	
}
