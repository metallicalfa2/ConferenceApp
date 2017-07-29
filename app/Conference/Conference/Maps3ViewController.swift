//
//  Maps3ViewController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 12/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Maps3ViewController: UIViewController,IndicatorInfoProvider{
	
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return IndicatorInfo(title: "Floor 3")
	}

}
