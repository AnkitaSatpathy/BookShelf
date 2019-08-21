//
//  Book.swift
//  BooksDemo
//
//  Created by 3Embed on 06/08/19.
//  Copyright © 2019 Demo. All rights reserved.
//

import Foundation

struct Book {
    var title = ""
    var author = ""
    var genre = ""
    var image = ""
    var country = ""
    var isBookmarked = false
    
    init(json: [String:Any]) {
        title = json["book_title"] as? String ?? ""
        author = json["author_name"] as? String ?? ""
        genre = json["genre"] as? String ?? ""
        image = json["image_url"] as? String ?? ""
        country = json["author_country"] as? String ?? ""
    }
}
