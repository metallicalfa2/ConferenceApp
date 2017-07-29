//
//  UIImageViewExtention.swift
//  Conference
//
//  Created by SKIXY-MACBOOK on 19/06/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit

extension UIImageView {
	public func imageFromServerURL(_ url: URL) {
		
		URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
			
			if error != nil {
				print(error ?? "error ocurred")
				return
			}
			DispatchQueue.main.async(execute: { () -> Void in
				let image = UIImage(data: data!)
				self.image = image
			})
			
		}).resume()
	}
}
