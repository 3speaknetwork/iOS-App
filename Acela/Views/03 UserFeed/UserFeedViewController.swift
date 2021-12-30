//
//  UserFeedViewController.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import UIKit

class UserFeedViewController: AcelaViewController {
	let viewModel = UserFeedViewModel()
	@IBOutlet var tableView: UITableView!
	let refreshFeed = UIRefreshControl()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = viewModel.userName
		refreshFeed.addTarget(self, action: #selector(reloadData), for: .valueChanged)
		tableView.addSubview(refreshFeed)
		reloadData()
	}

	@objc func reloadData() {
		showHUD("Loading Data")
		viewModel.getFeed() { [weak self] result in
			guard let self = self else { return }
			self.hideHUD()
			self.refreshFeed.endRefreshing()
			switch result {
			case .success:
				self.tableView.reloadData()
			case .failure(let error):
				self.showAlert(message: "Something went wrong.\n\(error.localizedDescription)")
			}
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "videoDetails",
			 let sender = sender as? FeedModel,
			 let viewController = segue.destination as? VideoInfoViewController {
			viewController.viewModel.item = sender
		}
	}

	func loadVideoInfo(at: IndexPath) {
		let item = viewModel.userFeed[at.row]
		performSegue(withIdentifier: "videoDetails", sender: item)
	}
}

extension UserFeedViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.userFeed.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		if let vCell = cell as? VideosCell {
			let item = viewModel.userFeed[indexPath.row]
			vCell.updateData(item: item)
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		loadVideoInfo(at: indexPath)
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

	}

//	func loadNextPage(isTrending: Bool) {
//		showHUD("Loading Data")
//		viewModel.loadNextPage(isTrending) { [weak self] result in
//			guard let self = self else { return }
//			self.hideHUD()
//			self.refreshNewFeed.endRefreshing()
//			self.refreshTrendingFeed.endRefreshing()
//			switch result {
//			case .success:
//				self.tableViewNew.reloadData()
//				self.tableViewTrending.reloadData()
//			case .failure(let error):
//				self.showAlert(message: "Something went wrong.\n\(error.localizedDescription)")
//			}
//		}
//	}
}
