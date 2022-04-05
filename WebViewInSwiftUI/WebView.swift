//
//  WebView.swift
//  WebViewInSwiftUI
//
//  Created by Cristian Peña Barrios on 28/03/22.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    
    let url: URL
    @Binding var showLoading: Bool
    
    
    func makeUIView(context: Context) -> some UIView {
        
        let scriptSourceListener = """
            window.addEventListener('message', function(e) {
                window.webkit.messageHandlers.iosListener.postMessage(JSON.stringify(e.data));
            });
            """
        
        let script = WKUserScript(source: scriptSourceListener,
                                  injectionTime: .atDocumentEnd,
                                  forMainFrameOnly: false)
        
        let webViewPrefs = WKPreferences()
        
        
        
//        webViewPrefs.javaScriptEnabled = true
        webViewPrefs.javaScriptCanOpenWindowsAutomatically = true
        
        let webViewConf: WKWebViewConfiguration = WKWebViewConfiguration()
        webViewConf.preferences = webViewPrefs
        webViewConf.userContentController.addUserScript(script)
        webViewConf.userContentController.add(context.coordinator, name: "iosListener")
        
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.isUserInteractionEnabled = true
//        webView.configuration.preferences.javaScriptEnabled = true
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.keyboardDismissMode = .onDrag
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator {
            showLoading = true
        } didFinish: {
            showLoading = false
        }

    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    
    // receive message from wkwebview
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        print(message.body)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print(message.body)
        }
    }
    
    
    var didStart: () -> Void
    var didFinish: () -> Void
    
    init(didStart: @escaping () -> Void = {},
         didFinish: @escaping () -> Void = {}){
        self.didStart = didStart
        self.didFinish = didFinish

        
    }
    
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        didStart()
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        print("fin de la carga")
        didFinish()
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        print(error)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust  else {
            completionHandler(.useCredential, nil)
            return
        }
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }
    
//    func userContentController(_ userContentController: WKUserContentController,
//                               didReceive message: WKScriptMessage) {
//        print(message.body)
//        if message.name == "iosListener" {
//
//
//        }
//    }
}

//class WebViewScriptMessageHandler: NSObject, WKScriptMessageHandler {
//
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        print(message.body)
////        if message.name == "iosListener" {
////            //            print(message.body)
////            messageBody = message.body as? String
////            //            print(messageBody ?? "")
////            let origin = "\(message.frameInfo.request)"
////            if origin.contains(cURL) {
////                guard let messageBody = messageBody else { return }
////                let data = Data(messageBody.utf8)
////                do {
////                    let jsonMike = try JSONDecoder().decode(ResponsePostMessage.self,
////                                                            from: data)
////                    if jsonMike.method == "HAND_SHAKE" && jsonMike.azteca360 == postClient{
////                        self.sendDataStyle()
////                    }  else if jsonMike.method == "CREATE_INTENT"{
////                        self.sendIntent(eventId: jsonMike.eventId!)
////                    } else if jsonMike.method == "GET_AUTHENTICATION" && jsonMike.azteca360 == postClient{
////                        self.sendDataQR(a_Token: "token", eventId: jsonMike.eventId!)
////                    } else if jsonMike.method == "DOWNLOAD_QR_APPS" && jsonMike.azteca360 == postClient{
////                        self.showAlertApps()
////                    } else if jsonMike.method == "QR_GENERATED_SUCCESSFULLY" && jsonMike.azteca360 == postClient{
////                        guard let qr = jsonMike.payload?.qrCode else {
////                            return
////                        }
////                        sendResponseQR(qr: qr)
////                    } else if jsonMike.method == "VOUCHER_GENERATED_SUCCESSFULLY" && jsonMike.azteca360 == postClient{
////                        guard let voucher = jsonMike.payload?.voucher else {
////                            return
////                        }
////                        sendResponseVoucher(voucher: voucher)
////                    } else if jsonMike.method == "PROCESS_ERROR" && jsonMike.azteca360 == postClient {
////                        self.showAlertError()
////                    }
////
////                } catch {
////                    //                    print("end")
////                }
////            }
////        }
//    }
//}
