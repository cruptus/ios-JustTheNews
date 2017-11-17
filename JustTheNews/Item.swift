//
//  Item.swift
//  JustTheNews
//
//  Created by Jeremie Elbaz on 17/11/2017.
//  Copyright © 2017 Jeremie Elbaz. All rights reserved.
//

import Foundation

class Item {
    
    private var title : String!
    
    private var description: String!
    
    private var pubDate: String!
    
    private var link: String!
    
    private var imgLink: String!
    
    init() {
        self.title = ""
        self.description = ""
        self.pubDate = ""
        self.link = ""
        self.imgLink = ""
    }
    
    //MARK: Accessor
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func setDescription(_ description: String) {
        self.description = description
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func setPubDate(_ pubDate: String) {
        self.pubDate = pubDate
    }
    
    func getPubDate() -> String {
        return self.pubDate
    }
    
    func setLink(_ setLink: String) {
        self.link = setLink
    }
    
    func getLink() -> String {
        return self.link
    }
    
    func setImgLink(_ imgLink: String) {
        self.imgLink = imgLink
    }
    
    func getImgLink() -> String {
        return self.imgLink
    }
}
