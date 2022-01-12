//
//  VideoCommentsViewController.swift
//  Acela
//
//  Created by Sagar Kothari on 10/01/22.
//

import UIKit
import Down
import SDWebImage

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
			self.scanForChildren()
		}
	}

	func scanForChildren() {
		for i in 0..<viewModel.comments.count {
			if viewModel.comments[i].children > 0,
				 viewModel.comments.filter({ $0.parent_permlink == viewModel.comments[i].permlink }).isEmpty {
				viewModel.loadCommentChildren(for: i) { [weak self] result in
					self?.tableViewComments.reloadData()
					self?.scanForChildren()
				}
				return
			}
		}
	}
}

extension VideoCommentsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.comments.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		if let commentsCell = cell as? VideoCommentsCell {
			commentsCell.updateData(item: viewModel.comments[indexPath.row])
		}
		return cell
	}
}
