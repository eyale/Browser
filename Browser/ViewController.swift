  //
  //  ViewController.swift
  //  Browser
  //
  //  Created by Anton Honcharov on 16.07.2021.
  //

import UIKit
import WebKit

class ViewController: UIViewController {
    // MARK: - Properties
  var webView: WKWebView!
  static let url = "https://search.brave.com"

  // MARK: - IBOutlets

  @IBOutlet private var searchWrapper: UIView!
  @IBOutlet private var search: UITextField!

  @IBOutlet private var webViewResults: UIView!
  @IBOutlet private var backButton: UIButton!

}

  // MARK: - LifeCycle
extension ViewController  {
  override func viewDidLoad() {
    super.viewDidLoad()

    handleKeyboard()
    setupWebView()
    setupSearchField()
    setupBackButton()
  }
}


extension ViewController {
  func setupBackButton() {
    backButton.addTarget(self, action: #selector(onBackButton), for: .touchUpInside)
  }
  @objc func onBackButton(_ sender: UIButton) {
    print(webView.canGoBack)
    if webView.canGoBack {
      webView.goBack()
    }
  }
}

// MARK: - KeyboardBehaviour
extension ViewController {
  func handleKeyboard() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
  }
  @objc func keyboardWillShow(sender: NSNotification) {
    if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      UIView.animate(withDuration: 0.1, animations: { () -> Void in
        self.view.frame.origin.y -= keyboardSize.height
        print(keyboardSize.height)
      })
    }
//    self.view.frame.origin.y = -320 // Move view 150 points upward
  }

  @objc func keyboardWillHide(sender: NSNotification) {
    self.view.frame.origin.y = 0 // Move view to original position
  }
}

  // MARK: - WKWEbView
extension ViewController: WKNavigationDelegate {
  func setupWebView(url: String = url) {
    let webViewConfiguration = WKWebViewConfiguration()
    webViewConfiguration.websiteDataStore = WKWebsiteDataStore.nonPersistent()

    webView = WKWebView(frame: webViewResults.bounds, configuration: webViewConfiguration)
    webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    webView.navigationDelegate = self

    webViewResults.addSubview(webView)

    guard let url = URL(string: url) else { return }
    webView.allowsBackForwardNavigationGestures = true
    webView.load(URLRequest(url: url))
  }
}

// MARK: - Search
extension ViewController: UITextFieldDelegate {
  func setupSearchField() {
    search.delegate = self
    searchWrapper.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let searchField = textField
    guard let searchValue = searchField.text else { return true }

    setupWebView(url: "\(ViewController.url)/search?q=\(searchValue)&source=web")

    return true
  }
}
