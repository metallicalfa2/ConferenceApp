//
//  LoginViewController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 08/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import GGLSignIn
import GoogleSignIn
import Google
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import SVProgressHUD

// userDefaults for persistant data storage.
let userDefaults = UserDefaults.standard

class LoginViewController: UIViewController ,GIDSignInUIDelegate,GIDSignInDelegate,LoginButtonDelegate{
	let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
	let loginManager = LoginManager()

	@IBOutlet weak var registrationId: UITextField!
	
	@IBAction func registerButton(_ sender: Any) {
	}
	
	@IBAction func googleSignIn(_ sender: Any) {
		GIDSignIn.sharedInstance().signIn()
	}

	@IBAction func facebookSignIn(_ sender: Any) {
		manageFbLogin()
	}

    override func viewDidLoad() {
		
		
        super.viewDidLoad()
		self.hideKeyboard()
		GIDSignIn.sharedInstance().uiDelegate = self
		GIDSignIn.sharedInstance().delegate = self
		
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		if(returnIfGoogleAndFacebookSet()){
			DispatchQueue.main.async( execute:{
				SVProgressHUD.show(withStatus: "Loading")
			})
		}
		
		userDefaults.set(false, forKey: "isFacebookLoggedIn")
		userDefaults.set(false, forKey: "isGoogleLoggedIn")
		GIDSignIn.sharedInstance().clientID = "675818656106-34cmrg4hlu86julevmeiqenlbo2gn21n.apps.googleusercontent.com"
		GIDSignIn.sharedInstance().signInSilently()
		
		FBSDKProfile.enableUpdates(onAccessTokenChange: true)
		FBSDKAccessToken.refreshCurrentAccessToken(nil)
		print(FBSDKAccessToken.current() ?? " \n nil access token \n")
		
		if( FBSDKAccessToken.current() != nil){
			print(FBSDKAccessToken.current())
			userDefaults.set(true, forKey: "isFacebookLoggedIn")
			segueFurther()
		}
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		
//		DispatchQueue.main.async( execute:{
//			SVProgressHUD.dismiss()
//		})
	}

	func segueFurther(){
		if ( (userDefaults.object(forKey: "name") != nil) && (userDefaults.object(forKey: "email") != nil) && (userDefaults.object(forKey: "title") != nil)  && (userDefaults.object(forKey: "company") != nil)  ) {
			DispatchQueue.main.async( execute:{
				let vc: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "tabView"))!
				self.present(vc, animated: true, completion: nil)
			})
		}
		else{
			DispatchQueue.main.async( execute:{
				let vc: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "loginDetails"))!
				self.present(vc, animated: true, completion: nil)
			})
		}
	}
	
}

extension LoginViewController{
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if (error == nil) {
			print(user.profile)
			let name = user.profile.name as String!
			let nameArray = name?.components(separatedBy: " ")
			userDefaults.set(nameArray![0], forKey: "firstName")
			userDefaults.set(nameArray![1], forKey: "lastName")
			
			userDefaults.set(user.profile.imageURL(withDimension: 500), forKey: "googleProfileImageUrl")
			userDefaults.set(true, forKey: "isGoogleLoggedIn")
			
			if(isValidEmail(user.profile.email)){
				userDefaults.set(user.profile.email as String!, forKey: "email")
			}

			userDefaults.set(user.profile.name as String!, forKey: "name")
			userDefaults.set(signIn.clientID as String!, forKey: "clientId")
			
			segueFurther()
		} else {
			print("\(error.localizedDescription)")
		}
	}
	
	override func manageFbLogin(){
		loginManager.logIn([.publicProfile, .email, .custom("user_work_history") ], viewController: self) { (result) in
			switch result{
			case .cancelled:
				print("Cancel button click")
			case .success:
				let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email, work"]
				let graphRequest = FBSDKGraphRequest.init(graphPath: "/me", parameters: params)
				let Connection = FBSDKGraphRequestConnection()
				Connection.add(graphRequest) { (Connection, result, error) in
					let info = result as! [String : AnyObject]
					//print(info)
					let dataObject = info["picture"] as! [String:AnyObject]
					let imageObject = dataObject["data"] as! [String:AnyObject]
					let imageString = imageObject["url"] as! String

					if (info["work"] != nil) {
						let work = info["work"] as! NSArray
						let workInfo = work[0] as! [String:AnyObject]
						let workposition = workInfo["position"]! as! [String:AnyObject]
						let workEmployer = workInfo["employer"]! as! [String:AnyObject]
						
						userDefaults.set(workposition["name"] as! String,forKey:"title")
						userDefaults.set(workEmployer["name"] as! String,forKey:"company")

					}
					userDefaults.set(FBSDKAccessToken.current().tokenString as String, forKey: "facebookAccessTokenKey")
					userDefaults.set(true,forKey:"isFacebookLoggedIn")
					
					if(self.canOpenURL(imageString)){
						userDefaults.set(URL(string:imageString), forKey: "facebookProfileImageUrl")
					}
					
					userDefaults.set(info["first_name"] as! String, forKey: "firstName")
					userDefaults.set(info["last_name"] as! String, forKey: "lastName")
					userDefaults.set(info["name"] as! String, forKey: "name")
					
					if (self.isValidEmail(info["email"] as! String)){
						userDefaults.set(info["email"] as! String, forKey: "email")
					}
					self.segueFurther()
				}
				Connection.start()
			default:
				print("??")
			}
		}
	}
	
	
	func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
		print("fb login completed")
	}
	func loginButtonDidLogOut(_ loginButton: LoginButton) {}
	
}
