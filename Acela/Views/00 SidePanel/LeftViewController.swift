//
//  LeftViewController.swift
//  Acela
//
//  Created by Sagar Kothari on 12/01/22.
//

import UIKit
import JASidePanels

class LeftViewCell: UITableViewCell {
	@IBOutlet var iconView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
}

class LeftViewController: UIViewController {
	@IBOutlet var tableView: UITableView!
	var selectedItem = 0

	let items = [
		("Home", UIImage(named: "home-logo")),
		("First Uploads", UIImage(named: "first-uploads")),
		("Trending Content", UIImage(named: "trending-logo")),
		("New Content", UIImage(named: "new-content-logo")),
		("Communities", UIImage(named: "communities-logo")),
		("Leaderboard", UIImage(named: "leaderboard-logo"))
	]

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension LeftViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		if let leftCell = cell as? LeftViewCell {
			leftCell.titleLabel?.text = items[indexPath.row].0
			leftCell.iconView?.image = items[indexPath.row].1
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if selectedItem != indexPath.row {
			loadPageAtIndex(indexPath.row)
		}
	}

	func loadPageAtIndex(_ index: Int) {
//		guard
//			let sidePanel = parent as? JASidePanelController,
//			let center = sidePanel.centerPanel as? UINavigationController,
//			let story = storyboard,
//			let videos = story.instantiateViewController(withIdentifier: "VideosViewController") as? VideosViewController
//		else { return }
//		switch index {
//		case 0:
//			videos.viewModel.feedType = .home
//		case 1:
////			videos.viewModel.feedType = .new
//			print("Do nothing")
//			return
//		case 2:
//			videos.viewModel.feedType = .trending
//		case 3:
//			videos.viewModel.feedType = .new
//		default:
//			print("Do nothing")
//			return
//		}
//		selectedItem = index
//		sidePanel.showCenterPanel(animated: true)
//		// center.setViewControllers([videos], animated: true)
//		center.pushViewController(videos, animated: true)
	}
}

