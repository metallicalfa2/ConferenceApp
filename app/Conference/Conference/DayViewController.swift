//
//  DayViewController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 29/05/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DayViewController:UIViewController, IndicatorInfoProvider{
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return IndicatorInfo(title: "Day 1")
	}
}
