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
    private var webView: WKWebView! {
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

        let appVersion = AppInfo.versionNumber
        let config = WKWebViewConfiguration()
        config.applicationNameForUserAgent = "MedMen/\(appVersion)"

        config.userContentController = WKUserContentController()
        config.userContentController.add(self, name: "mainSite")
        config.userContentController.add(self, name: "storeSite")

        webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(webView, at: 0)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: webView.topAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: webView.bottomAnchor),
            self.view.leftAnchor.constraint(equalTo: webView.leftAnchor),
            self.view.rightAnchor.constraint(equalTo: webView.rightAnchor)
        ])

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

    // For JS alert(message)
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {

        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))

        present(alertController, animated: true, completion: nil)
    }

    // For JS confirm(message)
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {

        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))

        present(alertController, animated: true, completion: nil)
    }

    // For JS prompt(text, defaultText)
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {

        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.text = defaultText
        }

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(nil)
        }))

        present(alertController, animated: true, completion: nil)
    }

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

// MARK: - WKScriptMessageHandler

extension WebViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("navigationMessage: \(message)")
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

extension WKScriptMessage {
    open override var description: String {
        return "WKScriptMessage name: \(self.name), body: \(self.body)"
    }
}
