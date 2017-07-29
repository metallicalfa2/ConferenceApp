//
//  ScheduleViewController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 29/05/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ScheduleViewController: ButtonBarPagerTabStripViewController {
	let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
	let blueColor = UIColor(red: 40/255, green: 179/255, blue: 1, alpha: 1)
		
	@IBOutlet weak var buttonBarOutlet: ButtonBarView!
	override func viewDidLoad() {
		// change selected bar color
		settings.style.buttonBarBackgroundColor = .white
		settings.style.buttonBarItemBackgroundColor = .white
		settings.style.selectedBarBackgroundColor = blueColor
		settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
		settings.style.selectedBarHeight = 2.0
		settings.style.buttonBarMinimumLineSpacing = 0
		settings.style.buttonBarItemTitleColor = .black
		settings.style.buttonBarLeftContentInset = 0
		settings.style.buttonBarRightContentInset = 0
		buttonBarOutlet.dropShadow()
		changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
			guard changeCurrentIndex == true else { return }
			oldCell?.label.textColor = .black
			newCell?.label.textColor = self?.blueColor
		
		}
		super.viewDidLoad()
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		
	}
	override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
		let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedule-day-1")
		let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedule-day-2")
		let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedule-day-3")
		return [child_1, child_2,child_3]
	}
}
