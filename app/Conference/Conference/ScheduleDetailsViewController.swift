//
//  ScheduleDetailsViewController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 17/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

class ScheduleDetailsViewController: UIViewController {
	
	var sessionIndex :Int = 0
	var session : sessionModel?
	var speaker: speakersModel?
	
	@IBOutlet weak var addToCalendar: UIButton!
	@IBOutlet weak var info: UILabel!
	@IBOutlet weak var speakerName: UILabel!
	@IBOutlet weak var eventName: UILabel!
	@IBOutlet weak var eventTime: UILabel!
	@IBOutlet weak var speakerImage: UIImageView!
	@IBOutlet weak var speakerTitle: UILabel!
	
	
	@IBAction func addToCalendar(_ sender: Any) {
		self.addCalendarEntry()
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		
		speakerImage.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(segueToSpeaker))
		speakerImage.addGestureRecognizer(tap)
		speakerImage.cornerRadius()
    }
	override func viewWillAppear(_ animated: Bool) {
		self.insertSessionDetailsFromDataModel()
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func insertSessionDetailsFromDataModel(){
		eventName.text = session!.name
		info.text = session!.description
		eventTime.text = ( session!.starttime ?? "" ) + " - " + ( session!.endtime ?? "" )
		getSpeakerDetails(session!.speakers!)

	}
	
	func getSpeakerDetails(_ arrayOfSpeakerIds:[String]){
		if(arrayOfSpeakerIds.count > 0){
			let id=arrayOfSpeakerIds[0]
			let array = speakersModel.speakers.filter{ $0.id == id }
			if(array.count > 0){
				speaker = array[0]
				speakerName.text = array[0].fname! + " " + array[0].lname!
				speakerImage.imageFromServerURL(URL(string: "https://www.eiseverywhere.com/image.php?acc=7157&id="+(speaker?.image)!)!)
			}
		}
		else{
			
		}
	}
	
	func segueToSpeaker(){
		let next = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "speakerPage") as? SpeakerDetailsViewController)!
		
		if(speaker != nil){
			next.speakerModel = speaker
			navigationController?.pushViewController(next, animated: true)
		}
	}
	
}
