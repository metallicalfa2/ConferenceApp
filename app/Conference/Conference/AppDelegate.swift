//
//  AppDelegate.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 28/05/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import GGLSignIn
import GoogleSignIn
import FBSDKLoginKit
import IQKeyboardManager
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate{

	var window: UIWindow?
	let net = networkResource()
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		//var configureError: NSError?
		IQKeyboardManager.shared().isEnabled = true
		IQKeyboardManager.shared().isEnableAutoToolbar = false
		IQKeyboardManager.shared().shouldShowTextFieldPlaceholder = false
		IQKeyboardManager.shared().keyboardDistanceFromTextField = 100
		
		FIRApp.configure()
		net.getToken()
		
//		GGLContext.sharedInstance().configureWithError(&configureError)
//		//assert(configureError == nil, "Error configuring Google services: \(configureError)")
//		GIDSignIn.sharedInstance().delegate = self
		
		 FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
		 return true
	}
	

	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
	}
	
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
		
		return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
	}
	
	
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		
	}
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		
	}
	func applicationWillResignActive(_ application: UIApplication) {
		FBSDKAppEvents.activateApp()

	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}

