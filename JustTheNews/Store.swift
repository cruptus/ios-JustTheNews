//
//  Store.swift
//  JustTheNews
//
//  Created by Jeremie Elbaz on 17/11/2017.
//  Copyright © 2017 Jeremie Elbaz. All rights reserved.
//

import Foundation

class Store: NSObject, URLSessionDataDelegate {
    
    
    //MARK: Attributs de la classe
    // URL de flux RSS à interroger
    private var rssDataURL: String
    // Buffer (tampon mémoire) pour les données
    private var dataBuffer: Data!
    // Référence sur le contrôleur de vue parent
    private var parentCTRL: MasterViewController
    
    //MARK: Initialisateur
    init(withRSSDataURL rssDataURL: String,
         parentCTRL: MasterViewController) {
        self.rssDataURL = rssDataURL
        self.parentCTRL = parentCTRL
    }
    
    func getData() {
        var httPostRequest: URLRequest!
        self.dataBuffer = nil
        
        let sessionConfig = URLSessionConfiguration.default
        
        let rssURL = URL(string:self.rssDataURL)
        
        httPostRequest = URLRequest(url:rssURL!)
        httPostRequest?.httpMethod = "POST"
        
        let mainSession = URLSession(configuration: sessionConfig,
                                     delegate: self, delegateQueue: OperationQueue.current)
        
        let mainTask = mainSession.dataTask(with: httPostRequest!)
        
        mainTask.resume()
    }
    
    //MARK : protocole URLSessionDataDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if (self.dataBuffer != nil ) {
            self.dataBuffer = self.dataBuffer + data
        } else {
            self.dataBuffer = data
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if(error != nil) {
            self.parentCTRL.networkErrorOccurred(pErrorMessage: error!.localizedDescription)
        } else {
            self.parentCTRL.receiveRSSData(pRSSRawData: self.dataBuffer)
        }
    }
    
}










