//
//  ScheduleViewCell.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 06/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

class ScheduleViewCell: UITableViewCell {
	
	@IBAction func calendarTapped(_ sender: Any) {
		let sender = sender as! UIButton
		sender.imageView?.image = #imageLiteral(resourceName: "calendar completed")
	}
	@IBOutlet weak var eventName: UILabel!
	@IBOutlet weak var speaker: UILabel!
	@IBOutlet weak var leftBar: UIView!
	@IBOutlet weak var location: UILabel!
	@IBOutlet weak var view: UIView!	
	@IBOutlet weak var calendarButton: UIButton!
	@IBOutlet weak var outerViewForCornerRadius: UIView!

}
