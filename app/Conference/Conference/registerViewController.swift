//
//  registerViewController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 14/07/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import Eureka
import SwiftyJSON
import SVProgressHUD

class registerViewController: FormViewController{
	let net = networkResource()
	var string = ""
	var index = 0
	let section = Section("Enter Details")
	var spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

	override func viewDidLoad() {
//		DispatchQueue.main.async( execute:{
//			SVProgressHUD.show(withStatus: "Loading")
//		})
//		
		super.viewDidLoad()
		net.getListPages()

		NotificationCenter.default.addObserver(self, selector: #selector(self.listPagesFetched), name: NSNotification.Name("listPagesFetched"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.listQuestionsFetched), name: NSNotification.Name("listQuestionsFetched"), object: nil)
		
	}
	
	func listPagesFetched(){
		SVProgressHUD.dismiss()
		
		let pages = networkResource.listPages.map{ $1 }.sorted(by: { (Int($0["pageid"].string!)!) < (Int($1["pageid"].string!)!) })
		//print(pages)
		
		if(index < 3){
			if let pageid = pages[index]["pageid"].string{
				string = pageid
			}
			if let page = pages[index]["page"].string {
				self.title = page
				let rightButton = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(donepressed))
				rightButton.title = "next"
				self.navigationItem.rightBarButtonItem = rightButton
			}
		}
	}
	
	func listQuestionsFetched(){
		let pages = networkResource.listQuestions.flatMap{ $0 }.map{ $1 }.filter{ $0["pageid"].string == string }
		//print(pages)
		

		if(index > 0 ){
			print(form[0].removeAll())
			for el in pages {
				section <<< EmailRow () {
					$0.title = el["name"].string
					$0.tag = el["fieldname"].string
				}
			}
		}
		else{
			for el in pages {
				section <<< EmailRow () {
					$0.title = el["name"].string
					$0.tag = el["fieldname"].string

				}
			}
			form +++ section

		}
		

		
	}
	
	func donepressed(){
		var id = ""
		self.index += 1
		
		if let email: EmailRow = form.rowBy(tag: "email"), let emailValue = email.value {
			if( index == 1){
				DispatchQueue.main.async(
					execute: {
						SVProgressHUD.show(withStatus: "registering")
					}
				)
				
				id = net.createAttendee(emailValue)
				print(" id is \(id)")
			}
		}
		if(index == 3){
			let vc: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "tabView"))!
			self.present(vc, animated: true, completion: nil)
		}
		listPagesFetched()
		listQuestionsFetched()
		print("done pressed")
	}
	
	func backpressed(){
		self.index -= 1
		print("index is \(index)")
	}
	
	func loader(){
		spinner.startAnimating()
	}

}
