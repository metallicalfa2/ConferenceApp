//
//  FilterViewController.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 07/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController{
	@IBOutlet var table: UITableView!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	@IBAction func cancelButtonClicked(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func saveButtonClicked(_ sender: Any) {
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		
	}
}
extension FilterTableViewController{
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
		return 5
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = table.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterTableViewCell
		cell.selectionStyle = .none
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = table.cellForRow(at: indexPath) as! FilterTableViewCell
		if  cell.filterImage?.isHidden == true {
			cell.filterImage?.isHidden = false
		}
		else{
			 cell.filterImage?.isHidden = true
		}
		
	}
	
}
