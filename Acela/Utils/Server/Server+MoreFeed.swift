//
//  Server+MoreFeed.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import Foundation

extension Server {
	func getMoreFeed(
		_ type: VideosFeedType,
		skip: Int? = nil,
		handler: @escaping (Result<MoreFeedModel, NSError>) -> Void
	) {
		var string = "\(server)\(type.moreEndPoint)"
		if let skip = skip {
			string = "\(string)/more?skip=\(skip)"
		}
		if let url = URL(string: string) {
			URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
				if let http = response as? HTTPURLResponse,
						http.statusCode == 200 {
					if let data = data {
						// home feed returns array
						if type == .home, let items = try? JSONDecoder().decode([FeedModel].self, from: data) {
							handler(.success(MoreFeedModel(trends: items, recommended: [])))
						// other feeds returns something else
						} else if let model = try? JSONDecoder().decode(MoreFeedModel.self, from: data) {
							handler(.success(model))
						} else {
							handler(.failure(self.jsonMappingFailed))
						}
					} else {
						handler(.failure(self.jsonMappingFailed))
					}
				} else {
					handler(.failure(self.statusCodeNot200))
				}
			}.resume()
		} else {
			handler(.failure(invalidUrlError))
		}
	}
}
