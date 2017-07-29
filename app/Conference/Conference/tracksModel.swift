//
//  tracksModel.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 21/07/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

class tracksModel{
	static var tracks : [tracksModel] = []
	
	var track_name:String
	var track_id:String
	
	init(_ track_name:String,track_id:String){
		self.track_name = track_name
		self.track_id = track_id
	}
}
