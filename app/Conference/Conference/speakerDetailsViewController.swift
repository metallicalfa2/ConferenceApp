//
//  speakerDetailsViewController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 22/07/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

class SpeakerDetailsViewController: UIViewController{
	var speakerModel: speakersModel?
	
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var bio: UILabel!
	@IBOutlet weak var titleSpeaker: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		insertDetails()
		self.title = "Speaker"
		image.cornerRadius()
	}
	
	public func insertDetails(){
		name.text = (speakerModel?.fname)! + " " + (speakerModel?.lname)!
		email.text = speakerModel?.company
		bio.text = speakerModel?.bio
		titleSpeaker.text = speakerModel?.title
		image.imageFromServerURL(URL(string: "https://www.eiseverywhere.com/image.php?acc=7157&id="+(speakerModel?.image)!)!)
	}
}
