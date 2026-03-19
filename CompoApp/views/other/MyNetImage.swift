//
//  MyNetImage.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//
import SwiftUI

struct MyNetImage: View {
    var url:String? = "https://theportablewife.com/wp-content/uploads/best-places-to-take-pictures-in-paris-newfeatured.jpg"
    var width:CGFloat = CGFloat.infinity
    var height:CGFloat = CGFloat.infinity
    var radius:CGFloat = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
        .fill(Color.gray.opacity(0.3))
        .frame(width: width, height: height)
        .overlay {
            AsyncImage(url: URL(string: url ?? "")) { phase in
                if let image = phase.image {
                    // Success: Display the loaded image with styling
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill, )
                        .frame(width: width, height: height)
                        .clipShape(RoundedCorner(radius: radius))
                } else if phase.error != nil {
                    // Failure: Display a system error image
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.yellow)
                } else {
                    
                }
            }
        }
    }
}


#Preview {
    MyNetImage(width: 200,height: 200)
}
