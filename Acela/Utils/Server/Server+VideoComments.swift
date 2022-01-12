//
//  Server+VideoComments.swift
//  Acela
//
//  Created by Sagar Kothari on 10/01/22.
//

import Foundation

// curl -s --data '{"jsonrpc":"2.0", "method":"condenser_api.get_content_replies", "params":["hiveio", "firstpost"], "id":1}' https://api.hive.blog

struct VideoCommentsRequest: Codable {
	var jsonrpc = "2.0"
	var method = "condenser_api.get_content_replies"
	var id = 1
	let params: [String]
}

struct VideoCommentResponse: Codable {
	let result: [VideoCommentResponseObject]
}

struct VideoCommentResponseObject: Codable {
	let author: String
	let permlink: String
	let body: String
	let created: String
	let children: Int
	let pending_payout_value: String
	let active_votes: [VideoCommentResponseVote]
	let depth: Int
	let parent_permlink: String
}

struct VideoCommentResponseVote: Codable {
	let percent: Int
}

extension Server {
	func getVideoComments(
		_ userName: String,
		permlink: String,
		handler: @escaping (Result<VideoCommentResponse, NSError>) -> Void
	) {
		if let url = URL(string: hiveServer) {
			var request = URLRequest(url: url)
			let requestParam = VideoCommentsRequest(params: [userName, permlink])
			if let data = try? JSONEncoder().encode(requestParam) {
				request.httpBody = data
				request.httpMethod = "POST"
				URLSession.shared.dataTask(with: request) { data, response, error in
					if let http = response as? HTTPURLResponse,
							http.statusCode == 200 {
						if let data = data,
							 let model = try? JSONDecoder().decode(VideoCommentResponse.self, from: data) {
							handler(.success(model))
						} else {
							handler(.failure(self.jsonMappingFailed))
						}
					} else {
						handler(.failure(self.statusCodeNot200))
					}
				}.resume()
			} else {
				handler(.failure(requestEncodingFailed))
			}
		} else {
			handler(.failure(invalidUrlError))
		}
	}
}
