//
//  StackViewExtention.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 21/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

extension UIStackView{
	override func cornerRadius(){
		let radius = self.frame.width / 2
		self.layer.cornerRadius = radius
		self.layer.masksToBounds = true
	}
}
