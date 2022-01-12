//
//  VideoCommentsCell.swift
//  Acela
//
//  Created by Sagar Kothari on 10/01/22.
//

import UIKit
import Down
import SwiftDate

class VideoCommentsCell: UITableViewCell {
	@IBOutlet var imageViewForUser: UIImageView!
	@IBOutlet var labelForTitle: UILabel!
	@IBOutlet var labelForSubtitle: UILabel!
	@IBOutlet var depthDistance: NSLayoutConstraint!

	func applyThemeing() {
		imageViewForUser.clipsToBounds = true
		imageViewForUser.layer.cornerRadius = 25
		imageViewForUser.layer.borderColor = UIColor.label.cgColor
		imageViewForUser.layer.borderWidth = 1
	}

	func updateData(item: VideoCommentResponseObject) {
		applyThemeing()
		if let down = try? Down(markdownString: item.body).toAttributedString() {
			labelForTitle?.attributedText = down
		} else {
			labelForTitle?.attributedText = nil
		}
		let time = item.created.toISODate(region: Region.current)?.toRelative(
			style: RelativeFormatter.twitterStyle(),
			locale: Locales.english) ?? ""
		let upvote = item.active_votes.filter { $0.percent > 0 }.count
		let downvote = item.active_votes.filter { $0.percent < 0 }.count
		let subTitle = "👤 \(item.author) 📆 \(time) 👍 \(upvote) 👎 \(downvote) 💰 \(item.pending_payout_value.replacingOccurrences(of: " HBD", with: ""))"
		labelForSubtitle.text = subTitle
		depthDistance.constant = CGFloat(item.depth) * 20.0 - 20.0
		if let thumb = URL(string: "https://images.hive.blog/u/\(item.author)/avatar") {
			imageViewForUser?.sd_setImage(
				with: thumb,
				placeholderImage: UIImage(named: "3-speak-logo"))
		} else {
			imageViewForUser?.image = UIImage(named: "3-speak-logo")
		}
	}
}
