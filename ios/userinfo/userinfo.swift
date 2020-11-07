//
//  userinfo.swift
//  userinfo
//
//  Created by  suke on 2020/10/24.
//

import WidgetKit
import SwiftUI
import Intents
import Alamofire

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),user: User(json: Dictionary()),image: nil, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),user: User(json: Dictionary()),image: nil, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        
        let url = URL(string: "https://www.v2ex.com/api/members/show.json?username=suke971219")!
        AF.request(url,method: HTTPMethod.get).responseJSON{
            response in
            switch(response.result){
            case .success(let json):
                let dict = json as! Dictionary<String,Any>
                let user = User(json: dict)
                
                guard let imageUrl = URL(string:user.avatar_large!) else {
                    return
                }
                URLSession.shared.dataTask(with: imageUrl){
                    (data,response,error) in
                    if let image = UIImage(data: data!){
                        
                        let entry = SimpleEntry(date: nextRefresh,user: user,image: image, configuration: configuration)
                        entries.append(entry)
                        let timeline = Timeline(entries: entries, policy: .after(nextRefresh))
                        completion(timeline)
                        
                    }else{
                        print(error ?? "err 加载图片失败")
                    }
                }.resume()
                
            case .failure(let err):
                print(err)
            }
        }
        
        
        
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let user:User
    let image:UIImage?
    let configuration: ConfigurationIntent
}

struct userinfoEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        v2User(image: entry.image, onGithubClick:{url in},onWebsiteClick: {url in}, user: entry.user)
    }
}

@main
struct userinfo: Widget {
    let kind: String = "userinfo"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            userinfoEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct userinfo_Previews: PreviewProvider {
    static var previews: some View {
        userinfoEntryView(entry: SimpleEntry(date: Date(),user: User(json: Dictionary()),image: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
