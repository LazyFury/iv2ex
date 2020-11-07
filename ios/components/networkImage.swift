//
//  networkImage.swift
//  v2widget
//
//  Created by  suke on 2020/10/24.
//

import SwiftUI


@available(iOS 14.0, *)
struct networkImage: View {
    let url:String;
    @State private var image:UIImage? = nil
    let placeholder = UIImage(named:"emptyImage")!
    
    func load(url:String){
        guard let imageUrl = URL(string:url) else {
            print("url\(url)")
            return
        }
        URLSession.shared.dataTask(with: imageUrl){
            (data,response,error) in
            if let img = UIImage(data: data!) {
                self.image = img
            }else{
                print(error ?? "err")
            }
        }.resume()
    }
    
    var body: some View {
       
            Image(uiImage:image ?? placeholder).resizable().onChange(of: url) { value in
                load(url:value)
            }.onAppear{
                load(url: url)
            }
        
    }
}

@available(iOS 14.0, *)
struct networkImage_Previews: PreviewProvider {

    static var previews: some View {
        networkImage(url: "https://suke100.oss-cn-beijing.aliyuncs.com/team.png")
            .previewLayout(.sizeThatFits)
    }
}
 
