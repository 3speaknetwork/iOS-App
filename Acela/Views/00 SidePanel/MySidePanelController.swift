//
//  MySidePanelController.swift
//  Acela
//
//  Created by Sagar Kothari on 12/01/22.
//

import Foundation
import JASidePanels

class MySidePanelController: JASidePanelController {

	override func awakeFromNib() {
		leftPanel = storyboard?.instantiateViewController(withIdentifier: "leftViewController")
		centerPanel = storyboard?.instantiateViewController(withIdentifier: "centerViewController")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
