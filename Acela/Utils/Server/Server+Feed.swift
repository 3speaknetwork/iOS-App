//
//  Server+Feed.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import Foundation

extension Server {
	func getFeed(
		_ type: VideosFeedType,
		handler: @escaping (Result<[FeedModel], NSError>) -> Void
	) {
		if let url = URL(string: "\(server)\(type.endPoint)") {
			URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
				if let http = response as? HTTPURLResponse,
						http.statusCode == 200 {
					if let data = data,
						 let model = try? JSONDecoder().decode([FeedModel].self, from: data) {
						handler(.success(model))
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
