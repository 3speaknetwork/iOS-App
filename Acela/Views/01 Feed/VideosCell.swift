//
//  VideosCell.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import UIKit

class VideosCell: UITableViewCell {
	@IBOutlet var cellTitle: UILabel!
	@IBOutlet var cellSubTitle: UILabel!
	@IBOutlet var cellViewCount: UILabel!
	@IBOutlet var cellImageView: UIImageView!
	@IBOutlet var cellShadowView: UIView!

	func applyBorder() {
		cellShadowView.layer.borderColor = UIColor.black.cgColor
		cellShadowView.layer.borderWidth = 2
		cellShadowView.layer.cornerRadius = 15
	}

	func updateData(item: FeedModel) {
		cellTitle?.text = item.title
		cellSubTitle?.text = "👤 \(item.author)"
		let duration = "\(Int(item.duration / 60)):\(Int(item.duration) % 60)"
		cellViewCount?.text = "  ▶️ \(item.views) 🕣 \(duration)  "
		if let thumbnail = item.images.thumbnail, let url = URL(string: thumbnail) {
			cellImageView?.sd_setImage(
				with: url,
				placeholderImage: UIImage(named: "3S_logo"))
		} else {
			cellImageView?.image = UIImage(named: "3S_logo")
		}
		applyBorder()
	}
}
