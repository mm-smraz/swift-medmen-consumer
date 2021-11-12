//
//  WebViewController.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit
import WebKit
import AppAuth

protocol WebViewControllerDelegate: class {
    func webViewControllerHandleAction(webViewController: WebViewController, action: MMWebAction)
    func webViewControllerLoadingStateChanged(webViewController: WebViewController, isLoading: Bool)
}

class WebViewController: MedMenViewController {

    var initURL: URL?
    var timeoutInterval: TimeInterval = 30
    weak var delegate: WebViewControllerDelegate?

    private(set) var isLoading: Bool = false {
        didSet {
            delegate?.webViewControllerLoadingStateChanged(webViewController: self, isLoading: self.isLoading)
        }
    }

    @IBOutlet private weak var progressV: UIView!
    @IBOutlet private weak var progressWidth: NSLayoutConstraint!
    private var webView: WKWebView! {
        didSet {
            webView.uiDelegate = self
            webView.navigationDelegate = self
        }
    }

    private var signInMng = SignInManager()

    private var progresKVOToken: NSKeyValueObservation?
    private var titleKVOToken: NSKeyValueObservation?

    static func instantiateFromStoryboard(initURL: URL? = nil, delegate: WebViewControllerDelegate? = nil) -> WebViewController {
        // swiftlint:disable:next force_unwrapping
        let vc = R.storyboard.webView.instantiateInitialViewController()!
        
        vc.initURL = initURL
        vc.delegate = delegate

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let navC = self.navigationController {
            navC.navigationBar.tintColor = UIColor.MM.lightGray

            navC.navigationBar.tintColor = .white

            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = UIColor.MM.lightGray
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

                navC.navigationBar.standardAppearance = appearance
                navC.navigationBar.compactAppearance = appearance
                navC.navigationBar.scrollEdgeAppearance = appearance
            } else {
                // Fallback on earlier versions
            }

        }

        let appVersion = AppInfo.versionNumber
        let config = WKWebViewConfiguration()
        config.applicationNameForUserAgent = "MedMen/\(appVersion)"

        config.userContentController = WKUserContentController()
        config.userContentController.add(self, name: "mainSite")

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

        setupKVO()

        reloadInitURL()
    }

    deinit {
        progresKVOToken?.invalidate()
        titleKVOToken?.invalidate()
    }

    private func setupKVO() {

        progresKVOToken = webView.observe(\.estimatedProgress, options: .new) { [weak self] (_, change) in
            print("WebView progress: \(String(describing: change.newValue))")
            self?.updateProgressBar()
        }

        titleKVOToken = webView.observe(\.title, options: .new) { (_, change) in
            print("WebView title: \((change.newValue ?? "??") ?? "??")")
        }
    }

    private func updateProgressBar() {
        progressWidth.constant = self.view.bounds.width * CGFloat(webView.estimatedProgress)

        let animationDuration = 0.2
        progressV.layer.removeAllAnimations()
        if webView.estimatedProgress > 0 && webView.estimatedProgress < 1 {
            if progressV.alpha != 1 {
                UIView.animate(withDuration: animationDuration) { [weak self] in
                    self?.progressV.alpha = 1
                }
            }
        } else {
            if progressV.alpha != 0 {
                UIView.animate(withDuration: animationDuration) { [weak self] in
                    self?.progressV.alpha = 0
                }
            }
        }
    }

    func reloadInitURL() {
        guard let url = self.initURL else {
            return
        }
        self.loadURL(url)
    }

    func runJavascript(_ js: String) {
        webView.evaluateJavaScript(js) { (result, error) in
            if let res = result {
                print("WebView JS result: \(res)")
            } else if let err = error {
                print("WebView JS error: \(err)")
            } else {
                print("WebView JS run finished")
            }
        }
    }

    func runWebFunction(_ webFunction: MMWebFunction) {
        runJavascript(webFunction.jsCode)
    }

    func loadURL(_ url: URL) {
        let req = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        self.loadRequest(req)
    }

    func loadRequest(_ request: URLRequest) {
        var req = request
        req.addValue(AppInfo.versionNumber, forHTTPHeaderField: "MedMen-Version")
        webView.load(req)
        self.isLoading = true
    }

}

// MARK: - WKUIDelegate

extension WebViewController: WKUIDelegate {

    // For JS alert(message)
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {

        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler()
        }))

        present(alertController, animated: true, completion: nil)
    }

    // For JS confirm(message)
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {

        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler(true)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
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

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            completionHandler(nil)
        }))

        present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        if let frame = navigationAction.targetFrame,
           frame.isMainFrame {
            return nil
        }

        let vc = delegate as? UIViewController ?? self
        if let config = SignInConfiguration.config(from: navigationAction.request.url) {
            signInMng.signIn(config: config, in: vc) { [weak self] (result) in
                switch result {
                case .success(let tokenId):
                    self?.runWebFunction(.googleHandler(tokenId: tokenId))

                case .failure(let error):
                    print("SIGN IN ERROR: \(error)")
                    MMPopupView.showError(error, in: vc)
                }
            }
        } else {
            webView.load(navigationAction.request)
        }

        return nil
    }

    func webActionsFromUrl(_ url: URL?) -> [MMWebAction] {
        guard let urlStr = url?.absoluteString,
              let hashIndex = urlStr.firstIndex(of: "#")
        else {
            return []
        }
        let hashPartIndex = urlStr.index(hashIndex, offsetBy: 1)
        let hashPart = urlStr[hashPartIndex...]

        print("HASH PART: \(hashPart)")

        var hashParams = [String: String]()
        var actions = [MMWebAction]()
        let parameterPairs = hashPart.split(separator: "&")
        for pair in parameterPairs {
            let parts = pair.split(separator: "=")
            if parts.count == 2 {
                let key = String(parts[0])
                let value = String(parts[1])
                hashParams[key] = value
                if let action = MMWebAction(key: key, value: value) {
                    actions.append(action)
                }
            }
        }

        return actions
    }

}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        print("navigationAction: \(navigationAction.navigationType) url: \(url?.absoluteString ?? "URL?")")

        let actions = webActionsFromUrl(url)
        guard actions.isEmpty else {
            for action in actions {
                delegate?.webViewControllerHandleAction(webViewController: self, action: action)
            }
            decisionHandler(.cancel)
            return
        }

        // TODO: if custom header needs to be kept also for links or redirects, then implement this: https://stackoverflow.com/questions/28984212/how-to-add-http-headers-in-request-globally-for-ios-in-swift

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let response = navigationResponse.response as? HTTPURLResponse,
              let url = navigationResponse.response.url else {
            decisionHandler(.cancel)
            return
        }

        if response.statusCode >= 500 {

            let vc = delegate as? UIViewController ?? self
            let vm = MMAlertVM(
                icon: .geoLeafSleep,
                title: "Oops!",
                message: "We’re experiencing a temporary outage, and are working hard to get back up and running soon.",
                actions: [
                    MMAlertAction(title: "Retry App", style: .primary, handler: { [weak self] in
                        self?.loadURL(url)
                    })
                ]
            )
            OverlayAlertVC.show(in: vc, viewModel: vm)

            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.isLoading = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.isLoading = false
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

        self.isLoading = false

        let nsError = error as NSError
        let failedUrl = nsError.userInfo[NSURLErrorFailingURLErrorKey] as? URL

        let title: String
        let message: String

        switch (nsError.domain, nsError.code) {
        case (NSURLErrorDomain, NSURLErrorTimedOut):
            title = "Timeout"
            message = "Your connection timed out.\nPlease try again."

        case (NSURLErrorDomain, NSURLErrorNotConnectedToInternet):
            title = "No Internet Connection"
            message = "It looks like there was a problem with your connection.\nPlease try again."

        case (NSURLErrorDomain, NSURLErrorCancelled):
            return

        case ("WebKitErrorDomain", 102): // Frame load interrupted - don's show error when load is canceled
            return

        default:
            title = "Oops!"
            message = "Something went wrong.\nPlease try again."
        }

        print("WebView error: \(error)")

        let vc = delegate as? UIViewController ?? self
        let vm = MMAlertVM(
            icon: .geoLeafAlert,
            title: title,
            message: message,
            actions: [
                MMAlertAction(title: "Retry", style: .primary, handler: { [weak self] in
                    if let url = failedUrl {
                        self?.loadURL(url)
                    } else {
                        self?.reloadInitURL()
                    }
                })
            ]
        )
        let pop = MMPopupView(viewModel: vm)
        pop.show(over: vc)
    }
}

// MARK: - WKScriptMessageHandler

extension WebViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("navigationMessage: \(message)")
        if message.name == "mainSite" {
            if let dict = message.body as? [String: Any] {
                if let cartItems = dict["cartItems"] as? Int {
                    let action = MMWebAction.cartItemsCount(count: cartItems)
                    delegate?.webViewControllerHandleAction(webViewController: self, action: action)
                }
            }
        }
    }

}

// MARK: - WKNavigationType CustomStringConvertible

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
