//
//  VideoInfoViewController.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import UIKit
import SwiftDate
import AVKit
import SafariServices
import MBProgressHUD

class VideoInfoViewController: AcelaViewController {
	@IBOutlet var tableView: UITableView!

	let viewModel = VideoInfoViewModel()
	let controller = AVPlayerViewController()
	var observer: NSKeyValueObservation?
	var player: AVPlayer? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		title = viewModel.item?.title ?? "No Title"
		updateData()
		triggerVideoPlay()
	}

	func updateData() {
		loadVideoInfo()
		loadComments()
	}

	@objc func triggerVideoPlay() {
		guard let item = viewModel.item else { return }
		if let ipfs = item.ipfs,
			 let url = URL(string: Server.shared.m3u8(isIpfs: true, identifier: ipfs)) {
			videoPlayer(url: url)
		} else if let url = URL(string: Server.shared.m3u8(isIpfs: true, identifier: item.permlink)) {
			videoPlayer(url: url)
		}
	}

	func videoPlayer(url: URL) {
		let player = AVPlayer(url: url)
		self.player = player
		controller.player = player
		player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
	}

	override func observeValue(
		forKeyPath keyPath: String?,
		of object: Any?,
		change: [NSKeyValueChangeKey : Any]?,
		context: UnsafeMutableRawPointer?
	) {
		guard let player = player else {
			return
		}
		if let obj = object as? AVPlayer,
				obj == player,
				keyPath == "status",
				player.status == .readyToPlay {
			present(controller, animated: true) {
				player.play()
			}
		}
	}

	@objc func showPlayer() {
		guard let player = player else {
			return
		}
		present(controller, animated: true) {
			player.play()
		}
	}

	deinit {
		player?.removeObserver(self, forKeyPath: "status")
	}

	func addShare() {
		let barButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		navigationItem.rightBarButtonItem = barButton
	}

	@objc func shareTapped() {
		guard
			let item = viewModel.item,
			let url = URL(string: "\(Server.shared.server)watch?v=\(item.author ?? item.owner ?? "")/\(item.permlink)")
		else { return }
		let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		present(activityViewController, animated: true, completion: nil)
	}

	func loadVideoInfo() {
		guard
			viewModel.videoInfo?.videoDesc == nil
		else {
			return
		}
		viewModel.getInfo() { [weak self] result in
			guard let self = self else { return }
			self.tableView.reloadData()
		}
	}

	func scanForChildren() {
		for i in 0..<viewModel.comments.count {
			if viewModel.comments[i].children > 0,
				 viewModel.comments.filter({ $0.parent_permlink == viewModel.comments[i].permlink }).isEmpty {
				viewModel.loadCommentChildren(for: i) { [weak self] result in
					self?.tableView.reloadData()
					self?.scanForChildren()
				}
				return
			}
		}
	}

	@objc func showUserFeed() {
		guard let author = viewModel.item?.author ?? viewModel.item?.owner else { return }
		performSegue(withIdentifier: "userFeed", sender: author)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let sender = sender as? String,
			 segue.identifier == "userFeed",
			 let viewController = segue.destination as? UserFeedViewController {
			viewController.viewModel.userName = sender
		}
	}

	func loadComments() {
		showHUD("Loading comments", view: self.tableView)
		viewModel.loadComments { [weak self] result in
			self?.hideHUD()
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				self?.tableView.reloadData()
				self?.scanForChildren()
			}
		}
	}
}

extension VideoInfoViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		3
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0: return 1
		case 1: return self.viewModel.videoInfo != nil ? 1 : 0
		case 2: return self.viewModel.comments.count
		default: return 0
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "VideosCell", for: indexPath)
			if let videosCell = cell as? VideosCell, let item = viewModel.item {
				videosCell.updateData(item: item)
				videosCell.handleTapOnVideo = showPlayer
			}
			return cell
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: "VideoInfoCell", for: indexPath)
			if let videoInfoCell = cell as? VideoInfoCell {
				videoInfoCell.updateData(description: self.viewModel.videoInfo?.videoDesc ?? "")
			}
			return cell
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCommentsCell", for: indexPath)
			if let videoCommentsCell = cell as? VideoCommentsCell, !viewModel.comments.isEmpty {
				videoCommentsCell.updateData(item: viewModel.comments[indexPath.row])
			}
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
			return cell
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
