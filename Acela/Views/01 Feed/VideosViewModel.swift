//
//  VideosViewModel.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import Foundation

class VideosViewModel {
	var feedItems: [FeedModel] = []
	var feedType: VideosFeedType = .home

	func getFeed(_ handler: @escaping (Result<Void, NSError>) -> Void) {
		Server.shared.getFeed(feedType) { response in
			OperationQueue.main.addOperation {
				switch response {
				case .success(let items):
					self.feedItems = items
					handler(.success(()))
				case .failure(let errr):
					handler(.failure(errr))
				}
			}
		}
	}

	func loadNextPage(
		handler: @escaping (Result<Void, NSError>) -> Void
	) {
		Server.shared.getMoreFeed(feedType, skip: feedItems.count) { response in
			OperationQueue.main.addOperation {
				switch response {
				case .success(let model):
					self.feedItems += self.feedType.getItems(model)
					handler(.success(()))
				case .failure(let errr):
					handler(.failure(errr))
				}
			}
		}
	}
}
