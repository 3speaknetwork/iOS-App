//
//  ViewController.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import UIKit
import SDWebImage

class VideosViewController: AcelaViewController {
	let viewModel = VideosViewModel()
	@IBOutlet var viewForSegment: UISegmentedControl!
	@IBOutlet var tableViewNew: UITableView!
	@IBOutlet var tableViewTrending: UITableView!
	let refreshNewFeed = UIRefreshControl()
	let refreshTrendingFeed = UIRefreshControl()

	override func viewDidLoad() {
		super.viewDidLoad()
		refreshNewFeed.addTarget(self, action: #selector(reloadData), for: .valueChanged)
		refreshTrendingFeed.addTarget(self, action: #selector(reloadData), for: .valueChanged)
		tableViewNew.addSubview(refreshNewFeed)
		tableViewTrending.addSubview(refreshTrendingFeed)
		viewForSegment.selectedSegmentIndex = 0
		tableViewNew.isHidden = true
		tableViewTrending.isHidden = false
		reloadData()
	}

	@IBAction func segmentChanged() {
		tableViewNew.isHidden = viewForSegment.selectedSegmentIndex == 0
		tableViewTrending.isHidden = viewForSegment.selectedSegmentIndex != 0
		if (viewModel.trendingFeed.isEmpty && viewForSegment.selectedSegmentIndex == 0) {
			reloadData()
		} else if (viewModel.newFeed.isEmpty && viewForSegment.selectedSegmentIndex == 1) {
			reloadData()
		}
	}

	@objc func reloadData() {
		showHUD("Loading Data")
		viewModel.getFeed(viewForSegment.selectedSegmentIndex == 0) { [weak self] result in
			guard let self = self else { return }
			self.hideHUD()
			self.refreshNewFeed.endRefreshing()
			self.refreshTrendingFeed.endRefreshing()
			switch result {
			case .success:
				self.tableViewNew.reloadData()
				self.tableViewTrending.reloadData()
			case .failure(let error):
				self.showAlert(message: "Something went wrong.\n\(error.localizedDescription)")
			}
		}
	}
}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tableView == tableViewNew ? viewModel.newFeed.count : viewModel.trendingFeed.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		if let vCell = cell as? VideosCell {
			let item = tableView == tableViewNew ? viewModel.newFeed[indexPath.row] : viewModel.trendingFeed[indexPath.row]
			vCell.updateData(item: item)
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if tableView == tableViewNew {
			if indexPath.row == viewModel.newFeed.count - 1 {
				loadNextPage(isTrending: false)
			}
		} else {
			if indexPath.row == viewModel.trendingFeed.count - 1 {
				loadNextPage(isTrending: true)
			}
		}
	}

	func loadNextPage(isTrending: Bool) {
		showHUD("Loading Data")
		viewModel.loadNextPage(isTrending)  { [weak self] result in
			guard let self = self else { return }
			self.hideHUD()
			self.refreshNewFeed.endRefreshing()
			self.refreshTrendingFeed.endRefreshing()
			switch result {
			case .success:
				self.tableViewNew.reloadData()
				self.tableViewTrending.reloadData()
			case .failure(let error):
				self.showAlert(message: "Something went wrong.\n\(error.localizedDescription)")
			}
		}
	}
}
