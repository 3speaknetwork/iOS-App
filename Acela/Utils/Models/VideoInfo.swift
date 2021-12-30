//
//  VideoInfo.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import Foundation

struct VideoInfo: Codable {
	let title: String
	let videoDesc: String
	let owner: String
	let duration: Double
	let permlink: String
	let thumbnail: String
	let community: String
	let tags: [String]
	let created: String
	let views: Int

	enum CodingKeys: String, CodingKey {
		case title, permlink, community, created
		case videoDesc = "description", tags = "tags_v2"
		case owner, duration, thumbnail, views
	}
}
