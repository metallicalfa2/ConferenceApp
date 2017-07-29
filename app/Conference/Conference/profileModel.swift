//
//  profileModel.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 17/07/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

class profile {

	static let profileInstance = profile()
	
	var name: String?
	var job: String?
	var title: String?
	var isGoogleLoggedIn: Bool?
	var isFacebookLoggedIn: Bool?
	var profileImage: String?
	
	func setValues(_ name: String?, job:String?, title:String?, isGoogleLoggedIn: Bool?, isFacebookLoggedIn: Bool?, profileImage: String?){
		self.name = name
		self.job = job
		self.title = title
		self.profileImage = profileImage
		self.isGoogleLoggedIn = isGoogleLoggedIn
		self.isFacebookLoggedIn = isFacebookLoggedIn
	}
	
	fileprivate init(){
		print("profile initialised. \n")
	}
	
}

