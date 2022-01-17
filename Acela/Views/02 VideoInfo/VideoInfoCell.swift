//
//  VideoInfoCell.swift
//  Acela
//
//  Created by Sagar Kothari on 17/01/22.
//

import Foundation
import UIKit
import Down
import SwiftDate

class VideoInfoCell: UITableViewCell {
	@IBOutlet var labelForTitle: UILabel!

	func updateData(description: String) {
		if let down = try? Down(markdownString: description).toAttributedString() {
			labelForTitle?.attributedText = down
		} else {
			labelForTitle?.attributedText = nil
		}
	}
}
