//
//  TodayViewController.swift
//  EpidemikWidget
//
//  Created by Ryan Bradford on 12/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
	
	var trendsView: TrendsWidgetView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		initTrendView()
		// Do any additional setup after loading the view from its nib.
    }
	
	func initTrendView() {
		trendsView = TrendsWidgetView(frame: self.view.frame)
		self.view.addSubview(trendsView)
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
		if trendsView != nil {
			trendsView.removeFromSuperview()
		}
		initTrendView()
        completionHandler(NCUpdateResult.newData)
    }
    
}
