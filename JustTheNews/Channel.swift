//
//  Channel.swift
//  JustTheNews
//
//  Created by Jeremie Elbaz on 17/11/2017.
//  Copyright © 2017 Jeremie Elbaz. All rights reserved.
//

import Foundation

class Channel {
    private var title: String!
    private var description: String!
    private var copyright: String!
    private var link: String!
    private var pubDate: String!
    private var imgLink: String!
    private var listOfItems:[Item]!
    
    init() {
        self.title = ""
        self.description = ""
        self.pubDate = ""
        self.link = ""
        self.imgLink = ""
        self.copyright = ""
        self.listOfItems = [Item]()
    }
    
    func addItem(_ item: Item) {
        self.listOfItems.append(item)
    }
    
    func getListOfItems() -> [Item]! {
        return self.listOfItems
    }
    
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
    
    func setCopyRight (_ copyright: String) {
        self.copyright = copyright
    }
    
    func getCopyRight() -> String {
        return self.copyright
    }
}
