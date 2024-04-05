// LICENSE DIALOG
// Copyright (C) 2024  Ilias Karim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
import SwiftUI
import WebKit

struct LicenseView: UIViewRepresentable {
  final class Coordinator: NSObject, WKNavigationDelegate {
    private let parent: LicenseView

    init(parent: LicenseView) {
      self.parent = parent
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      guard case navigationAction.navigationType = .other else {
        navigationAction.request.mainDocumentURL.map { url in
          UIApplication.shared.open(url)
        }
        decisionHandler(.cancel)
        return
      }

      decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      parent.isLoading = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
      print(error)
    }
  }

  @Binding fileprivate(set) var isLoading: Bool
  private let license: URL
  
  init(license: URL, isLoading: Binding<Bool>) {
    self._isLoading = isLoading
    self.license = license
  }

  func makeCoordinator() -> Coordinator {
    .init(parent: self)
  }

  func makeUIView(context: Context) -> WKWebView {
    let configuration = WKWebViewConfiguration()
    configuration.suppressesIncrementalRendering = true

    let preferences = WKPreferences()
    preferences.isTextInteractionEnabled = false
    configuration.preferences = preferences

    let css = """
    @media (prefers-color-scheme: dark) {
     body {
      background: black; color: white;
     }
    }
    body {
      font: -apple-system-body; text-align: justify;
    }
    """.components(separatedBy: .newlines).joined()

    let js = """
    var style = document.createElement("style");
    style.innerHTML = "\(css)";
    document.head.appendChild(style);

    var meta = document.createElement('meta');
    meta.setAttribute('name', 'viewport');
    meta.setAttribute('content', 'width=device-width,user-scalable=no,initial-scale=1,viewport-fit=cover');
    document.getElementsByTagName('head')[0].appendChild(meta);
    """

    let userContentController = WKUserContentController()
    userContentController.addUserScript(
      WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
    configuration.userContentController = userContentController

    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = context.coordinator
    webView.isOpaque = false
    webView.scrollView.bounces = false

    webView.loadFileURL(license, allowingReadAccessTo: license)
    return webView
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {
  }
}
