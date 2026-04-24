//
//  MyNetImage.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//
import SwiftUI

struct MyNetImage: View {
    var url:String? = nil
    private let  urlDefault:String = "https://theportablewife.com/wp-content/uploads/best-places-to-take-pictures-in-paris-newfeatured.jpg"
    var width:CGFloat = CGFloat.infinity
    var height:CGFloat = CGFloat.infinity
    var radius:CGFloat = 0
    var contentMode:ContentMode = .fill
    var isOval:Bool = false
    var bgColor: Color = Color.gray.opacity(0.3)
    
    var body: some View {
        
        let rc = isOval ? height*0.5 : radius
        Group {
            if bgColor != .clear {
                RoundedRectangle(cornerRadius: rc)
                    .fill(bgColor)
            } else {
                Color.clear
            }
        }
        .frame(width: width, height: height)
        .overlay {
            AsyncImage(url: URL(string: url ?? urlDefault)) { phase in
                if let image = phase.image {
                    // Success: Display the loaded image with styling
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: width, height: height)
                        .clipShape(RoundedRectangle(cornerRadius: rc))
                } else if phase.error != nil {
                    // Failure: Display a system error image
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.yellow)
                } else {
                    
                }
            }
        }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}


#Preview {
    MyNetImage(width: 200,height: 200)
}
