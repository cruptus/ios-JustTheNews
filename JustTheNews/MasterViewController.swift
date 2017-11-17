//
//  ViewController.swift
//  JustTheNews
//
//  Created by Jeremie Elbaz on 17/11/2017.
//  Copyright © 2017 Jeremie Elbaz. All rights reserved.
//

import UIKit

let URLS:[(String,String)] = [
    ("A la une", "https://www.lemonde.fr/rss/une.xml"),
    ("Actus", "https://www.lemonde.fr/m-actu/rss_full.xml"),
    ("Supérieur", "https://www.lemonde.fr/enseignement-superieur/rss_full.xml")
]

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var waitLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainTable: UITableView!
    
    @IBOutlet weak var selector: UIPickerView!
    
    private var dataSource: [Item]!
    private var imgNews: [Data]!
    private var storeObject: Store!
    
    var pickerData: [String] = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.storeObject = Store(withRSSDataURL: URLS[0].1, parentCTRL: self)
        
        storeObject.getData()
        self.dataSource = [Item]()
        self.imgNews = [Data!]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selector.delegate = self
        self.selector.dataSource = self
        
        for url in URLS {
            pickerData.append(url.0)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        self.waitMessage(hidden: false, "Lecture du Flux RSS, merci de patienter ...")
        let nibFile = UINib(nibName: "NewsCell", bundle: .main)
        self.mainTable.register(nibFile, forCellReuseIdentifier: "NewsCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receiveRSSData(pRSSRawData: Data) {
        
        self.waitMessage(hidden: false, "Interprétation du Flux rss, merci de patienter")
        let _ = RSSParser(withXMLData: pRSSRawData, andParentCTRL: self)
    }

    func waitMessage(hidden messageState:Bool=true, _ message: String = "Patientez, traitement en cours ...") {
        self.waitLabel.isHidden = messageState
        self.activityIndicator.isHidden = messageState
        self.waitLabel.text = message
    }
    
    func XMLDataParsed(channelList:[Channel]!) {
        self.waitMessage(hidden: true)
        
        for ch in channelList {
            let items = ch.getListOfItems()
            if (items != nil) {
                for item in items! {
                    self.dataSource.append(item)
                    self.imgNews.append(Data())
                }
            }
        }
        self.mainTable.reloadData()
    }
    
    func networkErrorOccurred(pErrorMessage: String) {
        let alertFrmCtrl = UIAlertController(title: "Network error", message: pErrorMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertFrmCtrl.addAction(OKAction)
        self.present(alertFrmCtrl, animated: true, completion: nil)
    }
    
    func xmlParserErrorOccurred(pErrorMessage: String) {
        let alertFrmCtrl = UIAlertController(title: "OK", message: pErrorMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertFrmCtrl.addAction(OKAction)
        self.present(alertFrmCtrl, animated: true, completion: nil)
    }
    
    
    //MARK: Protocole UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.row
        let newCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        let itemLig = self.dataSource[i]
        
        newCell.titre.text = itemLig.getTitle()
        newCell.datePublication.text = itemLig.getPubDate()
        newCell.Description.text = itemLig.getDescription()
        
        let imgData: Data! = self.imgNews[i]
        newCell.illustration.image = UIImage(data: Data())
        if (imgData.count > 0) {
            newCell.illustration.image = UIImage(data: imgData)
            newCell.imgLoadIndicator.stopAnimating()
            newCell.imgLoadIndicator.isHidden = true
        } else {
            newCell.imgLoadIndicator.startAnimating()
            newCell.imgLoadIndicator.isHidden = false
            newCell.updateImage(atRow: i, fromLink: itemLig.getImgLink(), forCTRL: self)
        }
        
        return newCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    
    func updateImageOfNews(withData data:Data!, atIndex index: Int) {
        if (data != nil) {
            self.imgNews[index] = Data(data)
        } else {
            self.imgNews[index] = Data()
        }
    }
    
    
    //MARK: picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.storeObject = Store(withRSSDataURL: URLS[row].1, parentCTRL: self)
        
        storeObject.getData()
        self.dataSource = [Item]()
        self.imgNews = [Data!]()
    }

}

