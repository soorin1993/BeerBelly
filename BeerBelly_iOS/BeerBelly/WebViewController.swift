//
//  WebViewController.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 12/13/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var beerStyleName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var newBeerStyleName = beerStyleName?.replacingOccurrences(of: " ", with: "+")
        
        var beerURL = "https://www.google.com/search?q=" + newBeerStyleName!
        print(beerStyleName)
        print(beerURL)
        let url = URL(string: beerURL);
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
