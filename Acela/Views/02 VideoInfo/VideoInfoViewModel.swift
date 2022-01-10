//
//  VideoInfoViewModel.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import Foundation

class VideoInfoViewModel {
	var item: FeedModel? = nil
	var videoInfo: VideoInfo? = nil
	var comments: [VideoCommentResponseObject] = []

	func getInfo(handler: @escaping (Result<Void, NSError>) -> Void) {
		guard videoInfo == nil else {
			handler(.success(()))
			return
		}
		guard let item = item else {
			handler(.success(()))
			return
		}
		Server.shared.getVideoInfo(item.author, permlink: item.permlink) { response in
			OperationQueue.main.addOperation {
				switch response {
				case .success(let info):
					self.videoInfo = info
					handler(.success(()))
				case .failure(let errr):
					handler(.failure(errr))
				}
			}
		}
	}

	func loadComments(_ handler: @escaping (Result<Void, NSError>) -> Void) {
		guard let item = item else {
			handler(.success(()))
			return
		}
		Server.shared.getVideoComments(
			item.author,
			permlink: item.permlink
		) { result in
			OperationQueue.main.addOperation {
				switch result {
				case .success(let info):
					self.comments = info.result
					handler(.success(()))
				case .failure(let errr):
					handler(.failure(errr))
				}
			}
		}
	}
}
