//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 25.09.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private lazy var webView = WKWebView()
    private lazy var progressView = UIProgressView()
    
    private let webViewURL: URL
    
    init(webViewURL: URL) {
        self.webViewURL = webViewURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        
        configureWebView()
        configureProgressView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            didUpdateProgressValue(webView.estimatedProgress)
        }
    }
    
    private func configureWebView() {
        webView.backgroundColor = UIColor(named: "YPWhite")
        
        let request = URLRequest(url: webViewURL)
        webView.load(request)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureProgressView() {
        progressView.tintColor = UIColor(named: "YPBlue")
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func didUpdateProgressValue(_ newValue: Double) {
        if abs(newValue - 1.0) <= 0.0001 {
            progressView.isHidden = true
        } else {
            progressView.progress = Float(newValue)
        }
    }
}
