//
//  UIViewControllerExtention.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 17/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import EventKit
import FBSDKLoginKit
import FacebookLogin
import Google
import GoogleSignIn

extension UIViewController {
	func showAlertMessage(_ titleStr:String, messageStr:String) {
		let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
		let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
			UIAlertAction in
			NSLog("OK Pressed")
		}
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}

	func addCalendarEntry(){
		let eventStore : EKEventStore = EKEventStore()
		
		//Access permission
		eventStore.requestAccess(to: EKEntityType.event) { (granted,error) in
			
			if (granted) &&  (error == nil) {
				print("permission is granted")
				
				let event:EKEvent = EKEvent(eventStore: eventStore)
				event.title = "Event Creater 1"
				event.startDate = NSDate() as Date
				event.endDate = NSDate() as Date
				event.notes = "This is a note of creating event"
				event.calendar = eventStore.defaultCalendarForNewEvents
				event.addAlarm(EKAlarm.init(relativeOffset: 60.0))
				do {
					try eventStore.save(event, span: .thisEvent)
					self.showAlertMessage("Event Saved", messageStr: "You will be notified before the event")
				} catch let specError as NSError {
					print("A specific error occurred: \(specError)")
				} catch {
					print("An error occurred")
				}
				print("Event saved")
				
			} else {
				print("need permission to create a event")
			}
		}
	}
	func manageFbLogin(){
		let loginManager = LoginManager()
		loginManager.logIn([.publicProfile, .email ], viewController: self) { (result) in
			switch result{
			case .cancelled:
				print("Cancel button click")
			case .success:
				let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
				let graphRequest = FBSDKGraphRequest.init(graphPath: "/me", parameters: params)
				let Connection = FBSDKGraphRequestConnection()
				Connection.add(graphRequest) { (Connection, result, error) in
					let info = result as! [String : AnyObject]
					let dataObject = info["picture"] as! [String:AnyObject]
					let imageObject = dataObject["data"] as! [String:AnyObject]
					let imageString = imageObject["url"] as! String
					
					userDefaults.set(true,forKey:"isFacebookLoggedIn")
					userDefaults.set(URL(string:imageString), forKey: "facebookProfileImageUrl")
					userDefaults.set(info["name"] as! String, forKey: "name")
					userDefaults.set(info["email"] as! String, forKey: "email")
				}
				Connection.start()
			default:
				print("??")
			}
		}
	}
	
	func manageFbLogout(){
		let loginManager = LoginManager()
		loginManager.logOut()
		userDefaults.set(false,forKey:"isFacebookLoggedIn")
		userDefaults.set(nil, forKey: "facebookProfileImageUrl")
	}
	func manageGoogleLogout(){
		GIDSignIn.sharedInstance().signOut()
		userDefaults.set(false,forKey:"isGoogleLoggedIn")
		userDefaults.set(nil, forKey: "googleProfileImageUrl")
	}
	
	func checkIfBothLoggedOut() -> Bool{
		if( !UserDefaults().bool(forKey: "isFacebookLoggedIn") && !UserDefaults().bool(forKey: "isGoogleLoggedIn") ){
			return true
		}
		return false
	}
	
	func clearUserDefaults(){
		userDefaults.set(nil, forKey: "email")
		userDefaults.set(nil, forKey: "name")
	}
	
	
	func hideKeyboard()
	{
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(UIViewController.dismissKeyboard))
		
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard()
	{
		view.endEditing(true)
	}
	func setTrueGoogleLoggedIn(){
		userDefaults.set(true, forKey: "isGoogleLoggedIn")
	}
	func setTrueFacebookLoggedIn(){
		userDefaults.set(true, forKey: "isFacebookLoggedIn")
	}
	
	func returnIfGoogleAndFacebookSet() -> Bool{
		return ( UserDefaults().bool(forKey: "isFacebookLoggedIn") || UserDefaults().bool(forKey: "isGoogleLoggedIn") )
	}
	
	func isValidEmail(_ testStr:String) -> Bool {
		// print("validate calendar: \(testStr)")
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: testStr)
	}
	
	func canOpenURL(_ string: String?) -> Bool {
		guard let urlString = string else {return false}
		guard let url = URL(string: urlString) else {return false}
		if !UIApplication.shared.canOpenURL(url as URL) {return false}
		
		//
		let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
		let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
		return predicate.evaluate(with: string)
	}
}

