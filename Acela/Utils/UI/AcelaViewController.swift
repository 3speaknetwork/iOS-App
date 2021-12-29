//
//  AcelaViewController.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import Foundation
import UIKit
import MBProgressHUD

class AcelaViewController: UIViewController {
	var hud: MBProgressHUD? = nil

	func showHUD(_ message: String) {
		OperationQueue.main.addOperation {
			self.hud?.hide(animated: false)
			self.hud = MBProgressHUD(view: self.view)
			self.hud?.button.titleLabel?.text = message
			self.view.addSubview(self.hud!)
			self.hud?.show(animated: false)
		}
	}

	func hideHUD() {
		OperationQueue.main.addOperation {
			self.hud?.hide(animated: false)
		}
	}

	func showAlert(_ title: String = "Alert", message: String) {
		OperationQueue.main.addOperation {
			let alert = UIAlertController(
				title: "Alert",
				message: message,
				preferredStyle: .alert
			)
			let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
			alert.addAction(action)
			self.present(alert, animated: true, completion: nil)
		}
	}
}
