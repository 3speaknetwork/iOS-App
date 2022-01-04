//
//  VideoInfoViewController.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import UIKit
import SwiftDate
import AVKit
import MarkdownView
import SafariServices

class VideoInfoViewController: AcelaViewController {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var subTitleLabel: UILabel!
	@IBOutlet var videoImageView: UIImageView!
	@IBOutlet var userImageView: UIImageView!
	@IBOutlet var shadowView: UIView!
	@IBOutlet var markDownView: MarkdownView!

	let viewModel = VideoInfoViewModel()
	let controller = AVPlayerViewController()
	var observer: NSKeyValueObservation?
	var player: AVPlayer? = nil
	var videoDesc = ""

	override func viewDidLoad() {
		super.viewDidLoad()
		title = viewModel.item?.title ?? "No Title"
		applyThemeing()
		updateData()
		triggerVideoPlay()
	}

	@objc func triggerVideoPlay() {
		guard let item = viewModel.item else { return }
		if item.isIpfs, let ipfs = item.ipfs,
			 let url = URL(string: Server.shared.m3u8(isIpfs: true, identifier: ipfs)) {
			videoPlayer(url: url)
		} else if !item.isIpfs, let url = URL(string: Server.shared.m3u8(isIpfs: true, identifier: item.permlink)) {
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
				if self.videoImageView.gestureRecognizers == nil || self.videoImageView.gestureRecognizers?.isEmpty == true {
					let tapPlayVideo = UITapGestureRecognizer(target: self, action: #selector(self.showPlayer))
					self.videoImageView.addGestureRecognizer(tapPlayVideo)
				}
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
			let url = URL(string: "\(Server.shared.server)watch?v=\(item.author)/\(item.permlink)")
		else { return }
		let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		present(activityViewController, animated: true, completion: nil)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loadVideoInfo()
	}

	func loadVideoInfo() {
		guard
			videoDesc.isEmpty
		else {
			self.markDownView.load(markdown: self.videoDesc)
			return
		}
		self.markDownView.load(markdown: "### Loading info\nPlease wait...")
		viewModel.getInfo() { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success:
				if let desc = self.viewModel.videoInfo?.videoDesc {
					self.videoDesc = desc
					self.markDownView.load(markdown: self.videoDesc)
				}
			case .failure(let error):
				self.markDownView.load(markdown: "### Error loading info.\n\(error.localizedDescription)")
			}
		}
	}

	func applyThemeing() {
		addShare()
		shadowView.layer.borderColor = UIColor.label.cgColor
		shadowView.layer.borderWidth = 1
		shadowView.layer.cornerRadius = 15
		videoImageView?.layer.cornerRadius = 15
		videoImageView?.clipsToBounds = true
		userImageView.clipsToBounds = true
		userImageView.layer.cornerRadius = 25
		userImageView.layer.borderColor = UIColor.label.cgColor
		userImageView.layer.borderWidth = 1
		let tapG = UITapGestureRecognizer(target: self, action: #selector(showUserFeed))
		userImageView.addGestureRecognizer(tapG)
		markDownView.onTouchLink = { [weak self] request in
			guard let url = request.url else { return false }
			if url.scheme == "file" {
				return false
			} else if url.scheme == "https" || url.scheme == "http" {
				let safari = SFSafariViewController(url: url)
				self?.navigationController?.present(safari, animated: true, completion: nil)
				return false
			} else {
				return false
			}
		}
	}

	func updateData() {
		guard let item = viewModel.item else { return }
		titleLabel?.text = item.title
		let duration = item.duration.toIntervalString(options: nil)
		let time = item.created.toISODate(region: Region.current)?.toRelative(
			style: RelativeFormatter.twitterStyle(),
			locale: Locales.english) ?? ""
		subTitleLabel?.text = "👤 \(item.author) ▶️ \(item.views) 🕣 \(duration) 📢 \(time)"
		if let thumbnail = item.images.thumbnail, let url = URL(string: thumbnail) {
			videoImageView?.sd_setImage(
				with: url,
				placeholderImage: UIImage(named: "3S_logo"))
			videoImageView?.contentMode = .scaleAspectFill
		} else {
			videoImageView?.contentMode = .scaleAspectFit
			videoImageView?.image = UIImage(named: "3S_logo")
		}
		if let thumb = URL(string: "https://images.hive.blog/u/\(item.author)/avatar") {
			userImageView?.sd_setImage(
				with: thumb,
				placeholderImage: UIImage(named: "3S_logo"))
			userImageView?.contentMode = .scaleAspectFill
		} else {
			userImageView?.contentMode = .scaleAspectFit
			userImageView?.image = UIImage(named: "3S_logo")
		}
	}

	@objc func showUserFeed() {
		guard let author = viewModel.item?.author else { return }
		performSegue(withIdentifier: "userFeed", sender: author)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let sender = sender as? String,
			 segue.identifier == "userFeed",
			 let viewController = segue.destination as? UserFeedViewController {
			viewController.viewModel.userName = sender
		}
	}
}
