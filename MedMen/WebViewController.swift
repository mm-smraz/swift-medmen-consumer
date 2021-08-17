//
//  WebViewController.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: class {
    func webViewControllerHandleAction(webViewController: WebViewController, action: String)
}

class WebViewController: UIViewController {

    var initURL: URL?
    weak var delegate: WebViewControllerDelegate?

    @IBOutlet private weak var ai: UIActivityIndicatorView!
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.uiDelegate = self
            webView.navigationDelegate = self
        }
    }

    static func instantiateFromStoryboard(initURL: URL? = nil, delegate: WebViewControllerDelegate? = nil) -> WebViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController

        vc.initURL = initURL
        vc.delegate = delegate

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor(named: "mmPrimaryRed")

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "mmPrimaryRed")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        reloadInitURL()
    }

    func reloadInitURL() {
        guard let url = self.initURL else {
            return
        }
        self.loadURL(url)
    }

    func loadURL(_ url: URL) {
        ai.startAnimating()
        let req = URLRequest(url: url)
        webView.load(req)
    }

}

// MARK: - WKUIDelegate

extension WebViewController: WKUIDelegate {


}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("navigationAction: \(navigationAction.navigationType) url: \(navigationAction.request.url?.absoluteString ?? "URL?")")
        print("targetFrame: \(navigationAction.targetFrame?.request.url?.absoluteString ?? "URL?")")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ai.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ai.stopAnimating()
    }
}


extension WKNavigationType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .linkActivated: return "linkActivated"
        case .formSubmitted: return "formSubmitted"
        case .backForward: return "backForward"
        case .reload: return "reload"
        case .formResubmitted: return "formResubmitted"
        case .other: return "other"
        @unknown default: return "unknown"
        }
    }
}
