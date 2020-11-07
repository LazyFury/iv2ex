//
//  v2User.swift
//  v2widget
//
//  Created by  suke on 2020/10/23.
//

import SwiftUI

@available(iOS 14.0, *)
struct v2User: View {
    let image:UIImage? //兼容widget，不能触发onshow事件
    let onGithubClick:((URL)->())?
    let onWebsiteClick:((URL)->())?
    let user:User;

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 6.0) {
                VStack {
                    HStack{
                        if image != nil{
                            Image(uiImage: (image ?? UIImage(named: "emptyImage"))!).resizable()
                        }else{
                            networkImage(url: user.avatar_large ?? "")
                        }
                    }
                    .frame(width: 80.0, height: 80.0)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white,lineWidth: 2))
                    .shadow(radius: /*@START_MENU_TOKEN@*/7/*@END_MENU_TOKEN@*/)
                    
                    
                }
                .padding([.top, .leading, .trailing], 10.0)
                /*@END_MENU_TOKEN@*/
                VStack(alignment: .leading) {
                    Text(user.username ?? "user~")
                        .font(.title)
                    Text("第\(user.id ?? 0)号会员")
                        .font(.caption2)
                        .fontWeight(.thin)
                    HStack {
                        Text("Github:").font(.caption2)
                        Button(action: {
                            guard  let url = URL(string: "https://github.com/Treblex") else{return}
                            print(url)
//                            UIApplication.shared.open(url)
                            onGithubClick!(url)
                        }, label: {
                            Text("\(user.github ?? "-")")
                                .font(.caption)
                        })
                    }
                    HStack {
                        Text("website:").font(.caption2)
                        Button(action: {
                            guard  let url = URL(string:user.website!) else{return}
                            print(url)
//                            UIApplication.shared.open(url)
                            onWebsiteClick!(url)
                        }, label: {
                            Text("\(user.website ?? "-")").font(.caption)
                        })
                    }
                    HStack {
                        Text("Twiter:")
                            .font(.caption2)
                        Button(action: {}, label: {
                            Text("\(user.twitter ?? "-")").font(.caption)
                        })
                    }
                }
                Spacer()
            }
            
            VStack(alignment: .leading) {
                Text(" \(user.day ?? "") 加入V2EX")
                    .font(.caption2)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .leading], 6.0)
            }
                
        }
        .padding(.all, 10.0)
        
    }
}

@available(iOS 14.0, *)
struct v2User_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            v2User(image: nil,onGithubClick: { url  in
                
            },onWebsiteClick: {_ in}, user: User(json: Dictionary()))
                
        }.frame(width: 320.0).previewLayout(.sizeThatFits)
    }
}



public struct User {
    var username:String?
    var website:String?
    var github:String?
    var avatar_normal:String?
    var avatar_large:String?
    var url:String?
    var created:Int?
    var location:String?
    var id:Int?
    var day:String?
    var twitter:String?
    
    init(json: Dictionary<String, Any>){
        self.username = json["username"] as? String
        self.website = json["website"] as? String
        if self.website != ""{
            do {
                let site = self.website ?? ""
                let re_website = try NSRegularExpression(pattern: "^(http[s]{0,1}://)|(//)", options:  .caseInsensitive)
                let hasProtol = re_website.numberOfMatches(in: site, options: .reportProgress, range: NSRange(location:0,length: self.website?.count ?? 0))
                debugPrint(hasProtol)
                if hasProtol <= 0{
                    self.website = "http://\(site)"
                }
            } catch {
                print("error")
            }
        }
        self.github = json["github"] as? String
        self.avatar_normal = json["avatar_normal"] as? String

        do {
             let re = try NSRegularExpression(pattern: "_mini", options: .caseInsensitive)
            
            let large = re.stringByReplacingMatches(in: self.avatar_normal ?? "", options: .reportProgress, range: NSRange(location: 0, length: self.avatar_normal?.count ?? 0), withTemplate: "_large")
            self.avatar_large = large
        } catch {
            self.avatar_large = self.avatar_normal
        }
        debugPrint(self.avatar_large ?? "")
        self.created = json["created"] as? Int
        self.location = json["location"] as? String
        self.id = json["id"] as? Int
        self.twitter = json["twitter"] as? String
        self.day = timeStampToCurrennTime(timeStamp: Double(self.created ?? 0))
    }
}
