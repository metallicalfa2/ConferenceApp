//
//  netwrokResource.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 08/07/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

var token:String = ""

class networkResource{
	
	let accessTokenRequest = "https://www.eiseverywhere.com/api/v2/global/authorize.json?accountid=7157&key=74b7ba663ce4885fd0c1ecefbb57fe8580e2a932"
	let eventid = "246511"
	static var listPages: JSON = []
	static var listQuestions: [JSON] = []
	static var currentPage : String = ""
	
	func getListPagesString(_ token:String) -> String {
		return "https://www.eiseverywhere.com/api/v2/ereg/listPages.json?accesstoken="+token+"&eventid=246511"
	}
	
	func getListQuestionsString(_ token:String,id:String) -> String{
		return "https://www.eiseverywhere.com/api/v2/ereg/listQuestions.json?accesstoken="+token+"&eventid=246511&pageid="+id
	}
	
	func postCreateAttendeeString(_ token:String,email:String) -> String{
		return "https://www.eiseverywhere.com/api/v2/ereg/createAttendee.json?accesstoken="+token+"&eventid=246511&email="+email
	}
	
	func getListSessionString(_ token:String) -> String{
		return "https://www.eiseverywhere.com/api/v2/ereg/listSessions.json?accesstoken="+token+"&eventid=246511"
	}
	
	func getSessionString(_ token:String,sessionKey:String,sessionId:String) -> String{
		return "https://www.eiseverywhere.com/api/v2/ereg/getSession.json?accesstoken="+token+"&eventid=246511&sessionkey="+sessionKey+"&sessionid="+sessionId+"&showhidden=1"
	}
	
	func getTracksString(_ token:String) -> String{
		return "https://www.eiseverywhere.com/api/v2/global/listTracks.json?accesstoken="+token
	}

	func getListSpeakers(_ token:String) -> String{
		return "https://www.eiseverywhere.com/api/v2/ereg/listSpeakers.json?accesstoken="+token+"&eventid=246511"
	}
	
	func getSpeaker(_ token:String, speakerId:String) -> String{
		return "https://www.eiseverywhere.com/api/v2/ereg/getSpeaker.json?accesstoken="+token+"&eventid=246511&speakerid="+speakerId
	}
	
	func getToken(){
		DispatchQueue.main.async(execute: {
			SVProgressHUD.setDefaultMaskType(.gradient)
			SVProgressHUD.show(withStatus: "loading")
		})
		
		Alamofire.request(accessTokenRequest, method: .get).responseJSON { response in
			print("Error in fetching token: \(String(describing: response.error))")
			
			let res: JSON
			if let json = response.result.value {
				res = JSON(json)
				print(res)
				if res["accesstoken"].string != nil {
					token = res["accesstoken"].string!
					self.listSessions(res["accesstoken"].string!)
					self.getTracks(token, withCompletion: self.dismissHUD)
					self.listSpeakers(token)
					//self.getListPages()
				}
				
			}
		}
	}
	
	func dismissHUD(){
		print("length of the tracks model is \(tracksModel.tracks.count) ")
		DispatchQueue.main.async(execute: {SVProgressHUD.dismiss()})	
	
	}
	func listSessions(_ token: String){
		Alamofire.request(getListSessionString(token), method: .get).responseJSON { response in
			print("Error in fetching listSessions: \(String(describing: response.error))")
			
			if let json = response.result.value {
				let data = JSON(json).map{ return $1 }
				
				data.forEach{ el in
					let session = sessionModel(id: el["sessionid"].string ?? "0", description: "sample desciption", name: el["name"].string ?? "sample name", startTime: el["starttime"].string ?? "stime", endTime: el["endtime"].string ?? "etime", sessiondate: el["sessiondate"].string ?? "-1", sessionKey: el["sessionkey"].string ?? "-1", speakerId: "")
					
					self.getSession(token,session: session)
				}
				

			}
		}
	}
	
	func getSession(_ token:String,session:sessionModel){
		let request =  getSessionString(token, sessionKey: session.sessionKey!, sessionId: session.sessionId!)
		Alamofire.request( request ,method: .get).responseJSON { response in
			print("Error in getSession: \(String(describing: response.error))")
			
			if let json = response.result.value {
				let data = JSON(json)
				//print(data)
				let tracks = data["session_tracks"].map{ return $1.string! }
				let speakers = data["speakers"].map{return $1["speakerid"].string!}
				//print(speakers)
				session.setSpeakers(speakers)
				session.setTracks(tracks)
				session.description = data["descriptions"]["eng"].string
				session.name = data["reportname"].string!
				
				//print(data["reportname"].string)
				
				if(session.sessiondate == "2017-07-14" ){
					sessionModel.sessionsDay1.append(session)
				}else if (session.sessiondate == "2017-07-15"){
					sessionModel.sessionsDay2.append(session)
				}else{
					sessionModel.sessionsDay3.append(session)
				}
				
				let notificationName = NSNotification.Name("sessionFetched")
				NotificationCenter.default.post(name: notificationName, object: nil)
			}
		}
	}
	
	func listSpeakers(_ token:String){
		Alamofire.request(getListSpeakers(token),method: .get).responseJSON { response in
			print("Error in fetching tracks: \(String(describing: response.error))")
			
			if let json = response.result.value {
				let data = JSON(json).map{ return $1 }
				data.forEach{ el in
					self.getSpeaker(el)
				}
			}
			
		}
	}
	
	func getSpeaker(_ speaker:JSON){
		Alamofire.request(getSpeaker(token, speakerId: speaker["speakerid"].string! ),method: .get).responseJSON { response in
			print("Error in fetching tracks: \(String(describing: response.error))")
			
			if let json = response.result.value {
				let data = JSON(json)
				//print(data)
				
				let ids = ["2"]
				let speakerIndividual = speakersModel(data["fname"].string ?? "name", mname: data["mname"].string ?? "" , lname: data["lname"].string ?? "" , email: data["email"].string ?? "" , title: data["title"].string! , company: data["company"].string ?? "" , bio: data["bio"].string ?? "", sessionIds: ids, id: data["speakerid"].string ?? "", image: data["image"].string ?? "")
		
				speakersModel.speakers.append(speakerIndividual)
				
				let notificationName = NSNotification.Name("sessionFetched")
				NotificationCenter.default.post(name: notificationName, object: nil)
			}
		}
	}
	
	
	func getTracks(_ token:String,withCompletion completion: @escaping () -> Void ){
		Alamofire.request(getTracksString(token),method: .get).responseJSON { response in
			print("Error in fetching tracks: \(String(describing: response.error))")
			
			if let json = response.result.value {
				let data = JSON(json).map{ return $1 }
				data.forEach{ el in
					let track = tracksModel(el["track_name"].string!, track_id:el["track_id"].string!)
					tracksModel.tracks.append(track)
				}
				completion()
			}
		}
	}
	
	
	func getListPages(){
		Alamofire.request(getListPagesString(token), method: .get).responseJSON { response in
			print("Error in getListPages: \(String(describing: response.error))")
			if let json = response.result.value {
				networkResource.listPages = JSON(json)
				let _ = JSON(json).map{ (index,value) -> String? in
					self.getListQuestions(value["pageid"].string!)
					return value["pageid"].string
				}
				
				let notificationName = NSNotification.Name("listPagesFetched")
				NotificationCenter.default.post(name: notificationName, object: nil)
			}
		}
	}
	
	func getListQuestions(_ id:String){
		Alamofire.request(getListQuestionsString(token, id: id), method: .get).responseJSON { response in
			print("Error in list questions: \(String(describing: response.error))")
			if let json = response.result.value {
				networkResource.listQuestions.append(JSON(json))
				
				if (networkResource.listPages.array?.count == networkResource.listQuestions.count){
					let notificationName = NSNotification.Name("listQuestionsFetched")
					NotificationCenter.default.post(name: notificationName, object: nil)
				}
	
			}
			
		}
	}
	
	func createAttendee(_ email:String) -> String{
		var test = ""
		Alamofire.request(postCreateAttendeeString(token, email: email), method: .post).responseJSON { response in
			print("Error: \(String(describing: response.error))")
			if let json = response.result.value {
				test = JSON(json)["attendeeid"].string!
				print(test)
				DispatchQueue.main.async(execute:{
					SVProgressHUD.dismiss()
					SVProgressHUD.showSuccess(withStatus: "Your attendee id is " + test)
				})
			}
			
		}
		return test
	}
	
	
}
