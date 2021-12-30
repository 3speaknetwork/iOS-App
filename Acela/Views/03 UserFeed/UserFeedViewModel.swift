//
//  UserFeedViewModel.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import Foundation

class UserFeedViewModel {
	var userName: String = ""
	var userFeed: [FeedModel] = []

	func getFeed(handler: @escaping (Result<Void, NSError>) -> Void) {
		Server.shared.getUserFeed(userName) { response in
			OperationQueue.main.addOperation {
				switch response {
				case .success(let items):
					self.userFeed = items
					handler(.success(()))
				case .failure(let errr):
					handler(.failure(errr))
				}
			}
		}
	}

//	func loadNextPage(
//		_ isTrending: Bool,
//		handler: @escaping (Result<Void, NSError>) -> Void
//	) {
//		Server.shared.getMoreFeed(
//			isTrending, skip: isTrending ? trendingFeed.count : newFeed.count
//		) { response in
//			OperationQueue.main.addOperation {
//				switch response {
//				case .success(let model):
//					if isTrending {
//						self.trendingFeed = model.trends ?? []
//					} else {
//						self.trendingFeed = model.recommended ?? []
//					}
//					handler(.success(()))
//				case .failure(let errr):
//					handler(.failure(errr))
//				}
//			}
//		}
//	}
}
