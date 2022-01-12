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
	@IBOutlet var tableView: UITableView!
	let refresh = UIRefreshControl()

	override func viewDidLoad() {
		super.viewDidLoad()
		refresh.addTarget(self, action: #selector(reloadData), for: .valueChanged)
		tableView.addSubview(refresh)
		title = viewModel.feedType.title
		reloadData()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	@objc func reloadData() {
		showHUD("Loading Data")
		viewModel.getFeed() { [weak self] result in
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
		let item = viewModel.feedItems[at.row]
		performSegue(withIdentifier: "videoDetails", sender: item)
	}
}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.feedItems.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		if let vCell = cell as? VideosCell {
			let item = viewModel.feedItems[indexPath.row]
			vCell.updateData(item: item)
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		loadVideoInfo(at: indexPath)
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == viewModel.feedItems.count - 1 {
			loadNextPage()
		}
	}

	func loadNextPage() {
		showHUD("Loading Data")
		viewModel.loadNextPage() { [weak self] result in
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

extension VideosViewController {
	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		 if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
				navigationController?.setNavigationBarHidden(true, animated: true)
		 } else {
				navigationController?.setNavigationBarHidden(false, animated: true)
		 }
	}
}
