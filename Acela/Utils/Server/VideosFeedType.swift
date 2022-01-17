//
//  VideosFeedType.swift
//  Acela
//
//  Created by Sagar Kothari on 12/01/22.
//

import Foundation

enum VideosFeedType {
	case trending
	case new
	case home

//	case firstUploads

	var endPoint: String {
		switch self {
		case .trending: return "apiv2/feeds/trending"
		case .new: return "apiv2/feeds/new"
		case .home: return "api/feed/more"
		}
	}

	var title: String {
		switch self {
		case .trending: return "Trending Content"
		case .new: return "New Content"
		case .home: return "Home"
		}
	}
}
