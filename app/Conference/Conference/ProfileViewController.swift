//
//  ProfileViewController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 17/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google
import FacebookLogin
import FBSDKLoginKit

class ProfileViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
	
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var titleatCompany: UITextField!
	@IBOutlet weak var company: UITextField!
	@IBOutlet weak var facebook: UIImageView!
	@IBOutlet weak var google: UIImageView!
	@IBAction func signOut(_ sender: Any) {
		createSignOutAlert()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		GIDSignIn.sharedInstance().uiDelegate = self
		GIDSignIn.sharedInstance().delegate = self
		profileImage.cornerRadius()
		self.addRecognizer()
		
		self.name.isEnabled = false
		self.email.isEnabled = false
		self.titleatCompany.isEnabled = false
		self.company.isEnabled = false
		//print(UserDefaults().object(forKey: "manualChosenImage") != nil)
    }
	override func viewWillAppear(_ animated: Bool) {
		email.text = UserDefaults().string(forKey: "email") ?? "email Address"
		let first = UserDefaults().string(forKey: "firstName") ?? "First"
		let last = UserDefaults().string(forKey: "lastName") ?? "last"
		name.text = first+" "+last
		titleatCompany.text = UserDefaults().string(forKey: "title") ?? "Title"
		company.text = UserDefaults().string(forKey: "company") ?? "Company"
		fetchProfileImage()
	}
	
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if (error == nil) {
			print(user.profile)
			userDefaults.set(user.profile.imageURL(withDimension: 500), forKey: "googleProfileImageUrl")
			userDefaults.set(true, forKey: "isGoogleLoggedIn")
			userDefaults.set(user.profile.email as String!, forKey: "email")
			userDefaults.set(user.profile.name as String!, forKey: "name")
			userDefaults.set(signIn.clientID as String!, forKey: "clientId")
		} else {
			print("\(error.localizedDescription)")
		}
	}
}

extension ProfileViewController{
	
	func GoogleLoggedIn(){
		userDefaults.set(true,forKey: "isGoogleLoggedIn")
		self.google.image = #imageLiteral(resourceName: "google_plus")
	}
	
	func facebookLoggedIn() {
		//print("facebook logged in \n")
		userDefaults.set(true,forKey: "isFacebookLoggedIn")
		self.facebook.image = #imageLiteral(resourceName: "facebook")
	}
	func googleLoggedOut(){
		userDefaults.set(false,forKey: "isGoogleLoggedIn")
		self.google.image = #imageLiteral(resourceName: "google_plus_inactive")
	}
	func facebookLoggedOut(){
		userDefaults.set(false,forKey: "isFacebookLoggedIn")
		self.facebook.image = #imageLiteral(resourceName: "facebook_inactive")
	}
	
	func addRecognizer(){
		let fbTapped = UITapGestureRecognizer(target: self, action: #selector(createFacebookAction))
		let googleTapped = UITapGestureRecognizer(target: self, action: #selector(createGoogleAction))
		facebook.isUserInteractionEnabled = true
		google.isUserInteractionEnabled = true
		facebook.addGestureRecognizer(fbTapped)
		google.addGestureRecognizer(googleTapped)
	}
	func segueToLoginView(){
		let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginView")
		self.present(vc!, animated: true, completion: nil)
	}
	
	func fetchProfileImage(){
		if(UserDefaults().object(forKey: "manualChosenImage") != nil){
			print("manual image chosen\n")
			let data = UserDefaults().object(forKey: "manualChosenImage")
			self.profileImage.image = UIImage(data: data as! Data)
		}
		else if( (UserDefaults().bool(forKey: "isGoogleLoggedIn") == true ) && (userDefaults.url(forKey: "googleProfileImageUrl") != nil) ){
			self.profileImage.imageFromServerURL(userDefaults.url(forKey: "googleProfileImageUrl")!)
		}
		else if( (UserDefaults().bool(forKey: "isFacebookLoggedIn") == true ) && (userDefaults.url(forKey: "facebookProfileImageUrl") != nil) ){
			self.profileImage.imageFromServerURL(userDefaults.url(forKey: "facebookProfileImageUrl")! )
		}
		
		if(UserDefaults().bool(forKey: "isGoogleLoggedIn") == true){
			self.GoogleLoggedIn()
		}
		
		if(UserDefaults().bool(forKey: "isFacebookLoggedIn") == true){
			self.facebookLoggedIn()
		}
	}
	
	func createFacebookAction() {
		let fbvalue = (UserDefaults().bool(forKey: "isFacebookLoggedIn") == false)
		
		let alertController = UIAlertController(title: "Facebook", message: fbvalue ? "Would you like to connect your facebook ?" : "Would you like to disconnect your facebook ?", preferredStyle: .alert)
		
		let sendButton = UIAlertAction(title: fbvalue ? "Sign in" : "Sign out", style: fbvalue ? .default : .destructive, handler: { (action) -> Void in
			//print("Ok button tapped")
			if(fbvalue){
				self.manageFbLogin()
				self.facebookLoggedIn()
			}
			else{
				self.manageFbLogout()
				self.facebookLoggedOut()
			}
			if(self.checkIfBothLoggedOut()){
				self.clearUserDefaults()
				self.segueToLoginView()
			}
		})
		
		let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
			print("Cancel button tapped")
		})
		
		alertController.addAction(sendButton)
		alertController.addAction(cancelButton)
		self.navigationController!.present(alertController, animated: true, completion: nil)
	}

	func createGoogleAction() {
		let googleValue = (UserDefaults().bool(forKey: "isGoogleLoggedIn") == false)
		
		let alertController = UIAlertController(title: "Google", message: googleValue ? "Would you like to connect your Google account ?" : "Would you like to disconnect your Google account ?", preferredStyle: .alert)
		
		let sendButton = UIAlertAction(title: googleValue ? "Connect" : "Disconnect", style: googleValue ? .default : .destructive, handler: { (action) -> Void in
			if(googleValue){
				GIDSignIn.sharedInstance().signIn()
				self.GoogleLoggedIn()
			}
			else{
				GIDSignIn.sharedInstance().signOut()
				self.googleLoggedOut()
			}
			if(self.checkIfBothLoggedOut()){
				self.clearUserDefaults()
				self.segueToLoginView()
			}
		})
		
		let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
			//print("Cancel button tapped")
		})
		
		alertController.addAction(sendButton)
		alertController.addAction(cancelButton)
		self.navigationController!.present(alertController, animated: true, completion: nil)
	}
	
	func createSignOutAlert(){
		let googleValue = (UserDefaults().bool(forKey: "isGoogleLoggedIn") == false)
		
		let alertController = UIAlertController(title: "Conference", message: "Would you like to disconnect all your accounts and sign out?", preferredStyle: .alert)
		
		let disconnectButton = UIAlertAction(title:"Disconnect", style: googleValue ? .default : .destructive, handler: { (action) -> Void in
			self.manageGoogleLogout()
			self.manageFbLogout()
			self.clearUserDefaults()
			self.segueToLoginView()
		})
		
		let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
			//print("Cancel button tapped")
		})
		
		alertController.addAction(disconnectButton)
		alertController.addAction(cancelButton)
		self.navigationController!.present(alertController, animated: true, completion: nil)

	}
	
}
