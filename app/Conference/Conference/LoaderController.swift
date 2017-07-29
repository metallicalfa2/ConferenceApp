//
//  LoaderController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 19/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

class LoaderController: NSObject {
	
	static let sharedInstance = LoaderController()
	fileprivate let activityIndicator = UIActivityIndicatorView()
	
	//MARK: - Private Methods -
	fileprivate func setupLoader() {
		removeLoader()
		
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .gray
	}
	
	//MARK: - Public Methods -
	func showLoader() {
		setupLoader()
		
		let appDel = UIApplication.shared.delegate as! AppDelegate
		let holdingView = appDel.window!.rootViewController!.view!
		
		DispatchQueue.main.async {
			self.activityIndicator.center = holdingView.center
			//holdingView.backgroundColor = UIColor.gray
			self.activityIndicator.startAnimating()
			holdingView.addSubview(self.activityIndicator)
			UIApplication.shared.beginIgnoringInteractionEvents()
		}
	}
	
	func removeLoader(){
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.removeFromSuperview()
			UIApplication.shared.endIgnoringInteractionEvents()
		}
	}
}
