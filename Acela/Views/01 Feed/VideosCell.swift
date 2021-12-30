//
//  VideosCell.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import UIKit
import SwiftDate

class VideosCell: UITableViewCell {
	@IBOutlet var cellTitle: UILabel!
	@IBOutlet var cellSubTitle: UILabel!
	@IBOutlet var cellImageView: UIImageView!
	@IBOutlet var cellUserImageView: UIImageView!
	@IBOutlet var cellShadowView: UIView!

	func applyThemeing() {
		cellShadowView.layer.borderColor = UIColor.label.cgColor
		cellShadowView.layer.borderWidth = 1
		cellShadowView.layer.cornerRadius = 15
		cellImageView?.layer.cornerRadius = 15
		cellImageView?.clipsToBounds = true
		cellUserImageView.clipsToBounds = true
		cellUserImageView.layer.cornerRadius = 25
		cellUserImageView.layer.borderColor = UIColor.label.cgColor
		cellUserImageView.layer.borderWidth = 1
	}

	func updateData(item: FeedModel) {
		applyThemeing()
		cellTitle?.text = item.title
		let duration = item.duration.toIntervalString(options: nil)
		let time = item.created.toISODate(region: Region.current)?.toRelative(
			style: RelativeFormatter.twitterStyle(),
			locale: Locales.english) ?? ""
		cellSubTitle?.text = "👤 \(item.author) ▶️ \(item.views) 🕣 \(duration) 📢 \(time)"
		if let thumbnail = item.images.thumbnail, let url = URL(string: thumbnail) {
			cellImageView?.sd_setImage(
				with: url,
				placeholderImage: UIImage(named: "3S_logo"))
			cellImageView?.contentMode = .scaleAspectFill
		} else {
			cellImageView?.contentMode = .scaleAspectFit
			cellImageView?.image = UIImage(named: "3S_logo")
		}
		if let thumb = URL(string: "https://images.hive.blog/u/\(item.author)/avatar") {
			cellUserImageView?.sd_setImage(
				with: thumb,
				placeholderImage: UIImage(named: "3S_logo"))
			cellUserImageView?.contentMode = .scaleAspectFill
		} else {
			cellUserImageView?.contentMode = .scaleAspectFit
			cellUserImageView?.image = UIImage(named: "3S_logo")
		}
	}
}
