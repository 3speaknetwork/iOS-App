//
//  VideoCommentsViewController.swift
//  Acela
//
//  Created by Sagar Kothari on 10/01/22.
//

import UIKit
import Down

class VideoCommentsViewController: UIViewController {
	@IBOutlet var tableViewComments: UITableView!
	var viewModel = VideoInfoViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = viewModel.item?.title ?? "No Title"
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.tableViewComments.reloadData()
		}
	}
}

extension VideoCommentsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.comments.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		if let down = try? Down(markdownString: viewModel.comments[indexPath.row].body).toAttributedString() {
			cell.textLabel?.attributedText = down
		} else {
			cell.textLabel?.attributedText = nil
		}
		return cell
	}
}
