//
//  RSSParser.swift
//  JustTheNews
//
//  Created by Jeremie Elbaz on 17/11/2017.
//  Copyright © 2017 Jeremie Elbaz. All rights reserved.
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    
    private var xmlReader:XMLParser!
    private var parentViewCTRL: MasterViewController
    private var currentChannel: Channel!
    private var currentNews: Item!
    private var dataBuffer: String!
    private var listOfChannels: [Channel]!
    
    init(withXMLData pXMLData: Data, andParentCTRL parentCTRL: MasterViewController) {
        self.parentViewCTRL = parentCTRL
        self.listOfChannels = [Channel]()
        self.dataBuffer = ""
        self.currentChannel = nil
        self.currentNews = nil
        super.init()
        self.xmlReader = XMLParser(data: pXMLData)
        self.xmlReader.delegate = self
        
        let response = self.xmlReader.parse()
        
        if (response) {
            self.parentViewCTRL.waitMessage()
        } else {
            self.parentViewCTRL.waitMessage(hidden: false)
            self.parentViewCTRL.xmlParserErrorOccurred(pErrorMessage: "The parsing operation is aborted.")
        }
    }
    
    func getListeOfChannel() -> [Channel]! {
        return self.listOfChannels
    }
    
    func description() {
        for channelElt in self.listOfChannels {
            print("------------------------------")
            print(channelElt.getTitle())
            print(channelElt.getPubDate())
            print(channelElt.getLink())
            print(channelElt.getImgLink())
            print(channelElt.getDescription())
            print("------------------------------")
            print("List des actualités")
            for item in channelElt.getListOfItems() {
                print("******************")
                print(item.getTitle())
                print(item.getPubDate())
                print(item.getDescription())
                print(item.getLink())
                print(item.getImgLink())
                print("******************")
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        self.dataBuffer = ""
        
        switch elementName {
        case "channel":
            self.currentChannel = Channel()
            self.listOfChannels.append(self.currentChannel)
        case "item":
            self.currentNews = Item()
            
        case "enclosure":
            if(self.currentNews != nil) {
                let urlImageActu = attributeDict["url"]!
                self.currentNews.setImgLink(urlImageActu)
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.dataBuffer = self.dataBuffer + string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
            case "title":
                if (self.currentNews != nil) {
                    self.currentNews.setTitle(self.dataBuffer)
                } else {
                    self.currentChannel.setTitle(self.dataBuffer)
                }
            case "description":
                if (self.currentNews != nil) {
                    self.currentNews.setDescription(self.dataBuffer)
                } else {
                    self.currentChannel.setTitle(self.dataBuffer)
                }
            case "item" :
                if (self.currentNews != nil) {
                    let Idx = self.listOfChannels.count - 1
                    self.listOfChannels[Idx].addItem(self.currentNews)
                    self.currentNews = nil
                }
            case "pubDate" :
                if (self.currentNews != nil) {
                    self.currentNews.setPubDate(self.dataBuffer)
                } else {
                    self.currentChannel.setPubDate(self.dataBuffer)
                }
            case "link" :
                if (self.currentNews != nil) {
                    self.currentNews.setLink(self.dataBuffer)
                } else {
                    self.currentChannel.setLink(self.dataBuffer)
                }
            case "url" :
                if (self.currentChannel != nil) {
                    self.currentChannel.setImgLink(self.dataBuffer)
                }
            default: break
        }
        self.dataBuffer = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //self.description()
        self.parentViewCTRL.XMLDataParsed(channelList: self.listOfChannels)
        self.parentViewCTRL.waitMessage(hidden: true)
    }
    
    
    
    
    
    
    
}
