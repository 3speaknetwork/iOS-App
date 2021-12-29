//
//  VideosViewModel.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import Foundation

class VideosViewModel {
	var trendingFeed: [FeedModel] = []
	var newFeed: [FeedModel] = []

	func getFeed(
		_ isTrending: Bool,
		handler: @escaping (Result<Void, NSError>) -> Void
	) {
		Server.shared.getFeed(isTrending) { response in
			OperationQueue.main.addOperation {
				switch response {
				case .success(let items):
					if isTrending {
						self.trendingFeed = items
					} else {
						self.newFeed = items
					}
					handler(.success(()))
				case .failure(let errr):
					handler(.failure(errr))
				}
			}
		}
	}

	func loadNextPage(
		_ isTrending: Bool,
		handler: @escaping (Result<Void, NSError>) -> Void
	) {
		Server.shared.getMoreFeed(
			isTrending, skip: isTrending ? trendingFeed.count : newFeed.count
		) { response in
			OperationQueue.main.addOperation {
				switch response {
				case .success(let model):
					if isTrending {
						self.trendingFeed = model.trends ?? []
					} else {
						self.trendingFeed = model.recommended ?? []
					}
					handler(.success(()))
				case .failure(let errr):
					handler(.failure(errr))
				}
			}
		}
	}
}
