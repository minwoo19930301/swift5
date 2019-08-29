//
//  ViewController.swift
//  TokenAsset
//
//  Created by wedatalab on 29/08/2019.
//  Copyright © 2019 wedatalab. All rights reserved.
//
import UIKit
import WebKit

class ViewController: UIViewController,WKUIDelegate {
    @IBOutlet var webView: WKWebView!
    @IBOutlet var back: UIBarButtonItem!
    @IBOutlet var forward: UIBarButtonItem!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
            webView.uiDelegate = self
            self.view.addSubview(webView)
            
            
            
            let myURL = URL(string: "https://m.blog.naver.com/rlaalsdn456456")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
            webView.allowsBackForwardNavigationGestures = true
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            var viewBounds:CGRect = self.view.bounds
            viewBounds.origin.y = UIApplication.shared.statusBarFrame.size.height;
            viewBounds.size.height = viewBounds.size.height - UIApplication.shared.statusBarFrame.size.height;
            self.webView.frame = viewBounds;
            
        }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        if webView.canGoBack{
            webView.goBack()
        }
    }
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        if webView.canGoForward{
            webView.goForward()
        }
    }
    
}

