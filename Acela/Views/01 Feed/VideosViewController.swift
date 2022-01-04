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
	@IBOutlet var tableView: UITableView!
	let refresh = UIRefreshControl()

	override func viewDidLoad() {
		super.viewDidLoad()
		refresh.addTarget(self, action: #selector(reloadData), for: .valueChanged)
		tableView.addSubview(refresh)
		viewForSegment.selectedSegmentIndex = 0
		reloadData()
	}

	@IBAction func segmentChanged() {
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
			self.refresh.endRefreshing()
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
			 let viewController = segue.destination as? VideoInfoViewController,
			 navigationController != nil {
			viewController.viewModel.item = sender
		}
	}

	func loadVideoInfo(at: IndexPath) {
		let item = viewForSegment.selectedSegmentIndex == 1 ? viewModel.newFeed[at.row] : viewModel.trendingFeed[at.row]
		performSegue(withIdentifier: "videoDetails", sender: item)
	}
}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewForSegment.selectedSegmentIndex == 1 ? viewModel.newFeed.count : viewModel.trendingFeed.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		if let vCell = cell as? VideosCell {
			let item = viewForSegment.selectedSegmentIndex == 1
			? viewModel.newFeed[indexPath.row] : viewModel.trendingFeed[indexPath.row]
			vCell.updateData(item: item)
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		loadVideoInfo(at: indexPath)
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if viewForSegment.selectedSegmentIndex == 1 {
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
		viewModel.loadNextPage(isTrending) { [weak self] result in
			guard let self = self else { return }
			self.hideHUD()
			self.refresh.endRefreshing()
			switch result {
			case .success:
				self.tableView.reloadData()
			case .failure(let error):
				self.showAlert(message: "Something went wrong.\n\(error.localizedDescription)")
			}
		}
	}
}
