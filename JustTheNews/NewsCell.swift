//
//  NewsCell.swift
//  JustTheNews
//
//  Created by Jeremie Elbaz on 17/11/2017.
//  Copyright © 2017 Jeremie Elbaz. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell, URLSessionDataDelegate {
    
    
    
    @IBOutlet weak var titre: UITextField!
    @IBOutlet weak var datePublication: UITextField!
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var illustration: UIImageView!
    @IBOutlet weak var imgLoadIndicator: UIActivityIndicatorView!
    
    private var urlImage: String!
    private var dataImage: Data!
    private var parentCTRL: MasterViewController!
    private var imgRow: Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.urlImage = nil
        self.dataImage = nil
        self.parentCTRL = nil
        self.imgRow = nil
    }
    
    func updateImage(atRow row: Int, fromLink link: String, forCTRL parentCTRL: MasterViewController) {
        self.imgRow = row
        let secureImgLink = link.replacingOccurrences(of: "http:", with: "https:")
        
        var httpGetRequest: URLRequest!
        
        self.dataImage = nil
        self.urlImage = secureImgLink
        self.parentCTRL = parentCTRL
        let sessionConfig = URLSessionConfiguration.default
        let imgURL = URL(string: secureImgLink)
        if (imgURL != nil) {
            httpGetRequest = URLRequest(url: imgURL!)
            httpGetRequest.httpMethod = "GET"
            let imgSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: .current)
            let imgTask = imgSession.dataTask(with: httpGetRequest!)
            imgTask.resume()
            
        }
    }
    
    func getDataImage() -> Data? {
        return self.dataImage
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if (self.dataImage != nil) {
            self.dataImage = self.dataImage + data
        } else {
            self.dataImage = data
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if (error != nil) {
            self.dataImage = Data()
        }
        self.parentCTRL!.updateImageOfNews(withData: self.dataImage, atIndex: self.imgRow)
    }
    
    
    
    
}
