//
//  sessionClass.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 08/07/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

class sessionModel{

	static var sessionsDay1 : [sessionModel] = []
	static var sessionsDay2 : [sessionModel] = []
	static var sessionsDay3 : [sessionModel] = []
	
	var sessionId: String?
	var description: String?
	var endtime: String?
	var location:String?
	var name:String?
	var sessiondate:String?
	var sessiontype:String?
	var speakers: [String]?
	var starttime: String?
	var tracks: [String]?
	var sessionKey: String?
	var speakerId:String?
	
	init (id: String?, description: String?, name:String?, startTime:String? , endTime:String?, sessiondate: String?, sessionKey: String?, speakerId:String?){
		self.sessionId = id!
		self.description = description
		self.name = name
		self.starttime = startTime
		self.endtime = endTime
		self.sessiondate = sessiondate
		self.sessionKey = sessionKey
		self.speakerId = speakerId
	}
	
	func setSpeakers(_ speakers:[String]?){
		self.speakers = speakers
	}
	
	func setTracks(_ tracks:[String]?){
		self.tracks = tracks
	}
}



