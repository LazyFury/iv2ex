//
//  WebView.swift
//  v2ex
//
//  Created by  suke on 2020/10/26.
//

import SwiftUI
import WebKit

struct WebView:UIViewRepresentable {
    let url:String!
    let contentController = ContentController()
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let controller = WKUserContentController()
        let preferences = WKPreferences()
        preferences.minimumFontSize = 12.0
        controller.add(contentController,name: "hello")
        config.userContentController = controller
        config.preferences = preferences
       
        let webView = WKWebView(frame: .init(),configuration: config)
 
        if let url = URL(string:url){
            let req = URLRequest(url: url)
            webView.load(req)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }

    
    class ContentController:NSObject,WKScriptMessageHandler{
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
           print(message)
        }

    }
    
    typealias UIViewType = WKWebView
    
    
}


struct WebView_Previews:PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews:some View{
        WebView(url:"http://www.baidu.com")
    }
}
