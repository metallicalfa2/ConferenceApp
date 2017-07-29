//
//  extentions.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 07/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

extension UIView {
	
	func dropShadow(_ scale: Bool = true) {		
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.18
		self.layer.shadowOffset = CGSize(width: 1, height: 1)
		self.layer.shadowRadius = 2
		self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
		self.layer.shouldRasterize = true
		self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
	
	func cornerRadius(){
		let radius = self.frame.width / 2
		self.layer.cornerRadius = radius
		self.layer.masksToBounds = true
	}
	
	func cornerRadiusForTableViewCell(){
		self.layer.cornerRadius = 2
//		self.layer.masksToBounds = true
	}
}
extension ButtonBarView{
	override func dropShadow(_ scale: Bool = true) {
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.gray.cgColor
		self.layer.shadowOpacity = 0.2
		self.layer.shadowOffset = CGSize(width: 0, height: 1)
		self.layer.shadowRadius = 1
		self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
		self.layer.shouldRasterize = true
		self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
}
