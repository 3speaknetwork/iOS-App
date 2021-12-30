//
//  VideoInfoViewController.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import UIKit
import SwiftDate
import WebKit

class VideoInfoViewController: AcelaViewController {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var subTitleLabel: UILabel!
	@IBOutlet var videoImageView: UIImageView!
	@IBOutlet var userImageView: UIImageView!
	@IBOutlet var shadowView: UIView!
	@IBOutlet var infoWebView: WKWebView!

	let viewModel = VideoInfoViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = viewModel.item?.title ?? "No Title"
		applyThemeing()
		updateData()
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
		showHUD("Loading Data", view: infoWebView)
		viewModel.getInfo() { [weak self] result in
			guard let self = self else { return }
			self.hideHUD()
			switch result {
			case .success:
				if let desc = self.viewModel.videoInfo?.videoDesc {
					self.infoWebView.loadHTMLString(desc, baseURL: URL(string: Server.shared.server)!)
				}
			case .failure(let error):
				self.showAlert(message: "Something went wrong.\n\(error.localizedDescription)")
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
	}

	func updateData() {
		infoWebView.navigationDelegate = self
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

extension VideoInfoViewController: WKNavigationDelegate {
	func webView(
		_ webView: WKWebView,
		decidePolicyFor navigationAction: WKNavigationAction
	) async -> WKNavigationActionPolicy {
		return navigationAction.navigationType == .linkActivated ? WKNavigationActionPolicy.cancel : WKNavigationActionPolicy.allow
	}
}
