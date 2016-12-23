//
//  LicenseViewController.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 12/22/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    @IBOutlet weak var alamofire: UITextView!
    @IBOutlet weak var swiftyJSON: UITextView!
    @IBOutlet weak var googleFonts: UILabel!
    @IBOutlet weak var breweryDB: UILabel!
    @IBOutlet weak var beerBottle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        alamofire.showsVerticalScrollIndicator = true
        alamofire.layer.cornerRadius = 5

        swiftyJSON.showsVerticalScrollIndicator = true
        swiftyJSON.layer.cornerRadius = 5

        
        alamofire.text = "Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)" + "\n\n" + "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:" + "\n\n" + "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." + "\n\n" + "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
        
        swiftyJSON.text = "The MIT License (MIT)" + "\n\n" + "Copyright (c) 2016 Ruoyu Fu" + "\n\n" + "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:" + "\n\n" + "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." + "\n\n" + "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
        
        breweryDB.text = "This product uses the BreweryDB API but is not endorsed or certified by PintLabs."
        
        googleFonts.text = "Bungee-Regular.ttf: Copyright 2008 The Bungee Project Authors (david@djr.com)" + "\n" + "OpenSans-Regular.ttf: Digitized data copyright © 2010-2011, Google Corporation."
        beerBottle.text = "https://icons8.com/web-app/1823/Beer-Bottle"

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
