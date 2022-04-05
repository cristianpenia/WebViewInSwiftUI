//
//  ContentView.swift
//  WebViewInSwiftUI
//
//  Created by Cristian Peña Barrios on 28/03/22.
//

import SwiftUI
//import WebKit
import Azteca360
//extension View {
//    func toAnyView() -> AnyView {
//        AnyView(self)
//    }
//}

struct ContentView: View {
    
    @State private var showLoading: Bool = false
    
    var body: some View {
    
        VStack {
            
            ViewControllerRepresentable()
//            ViewControllerRepresentable()
//            
//            WebView(url: URL(string: "http://10.89.164.49:4200/#/payment-gateway/card/?channelId=iOS")!,
//                    showLoading: $showLoading)
//                .overlay(showLoading ? ProgressView("Loading...").toAnyView(): EmptyView().toAnyView())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
