//
//  EntryViewCell.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/20/24.
//

import SwiftUI

struct EntryViewCell: View {
    
    @State var backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    @State var portraitOffsetX: CGFloat = 50.0
    @State var cellOpacity: CGFloat = 0.0
    
    let index: Int
    let pokemonName: String
    var adjustedTextColor: UIColor {
        var h: CGFloat = 0.0,
            s: CGFloat = 0.0,
            b: CGFloat = 0.0,
            a: CGFloat = 0.0
        if backgroundColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            b += 0.9
            b = max(min(b, 1.0), 0.0)
            return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        }
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Rectangle()
                    .frame(width: 600, height: 300)
                    .foregroundStyle(
                        Color(backgroundColor)
                            .opacity(0.2)
                    )
                    .rotationEffect(Angle(degrees: 60))
                    .offset(x: 110, y: -60)
                
                //MARK: 포켓몬 이름
                VStack(alignment: .leading) {
                    //도감넘버
                    Capsule()
                        .foregroundStyle(Color.black)
                        .frame(width: 70, height: 24, alignment: .leading)
                        .overlay {
                            Text("No.\(index + 1)")
                                .font(Font.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                        }
                        .offset(x: 12, y: 30.0)
                    
                    //이름
                    Text(pokemonName.capitalized)
                        .frame(width: proxy.frame(in: .local).width / 2, alignment: .leading)
                        .padding()
                        .fontWeight(.heavy)
                        .font(Font.system(size: 30))
                        .foregroundStyle(Color(adjustedTextColor))
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                        .offset(y: 15)
                }
                
                //MARK: 포켓몬 이미지
                AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index+1).png")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 140, height: 140)
                            .onAppear {
                                withAnimation(.easeOut(duration: 0.3).delay(0.1)) {
                                    portraitOffsetX = 0
                                }
                            }
                    } else {
                        ProgressView()
                            .frame(width: 10, height: 140)
                    }
                }
                .offset(x: proxy.frame(in: .local).maxX - (140 - portraitOffsetX), y: proxy.frame(in: .local).maxY - 140)
                
            }
            .frame(minWidth: 200, maxWidth: .infinity)
            .clipShape(.rect)
            .backgroundStyle(Color(backgroundColor))
            .background(Color(backgroundColor).opacity(0.1))
            .onAppear {
                Task {
                    try await getDominantColorFromImage(urlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index+1).png")
                }
            }
        }
        .opacity(cellOpacity)
        .background(Color.black)
        .onAppear {
            withAnimation(.easeOut(duration: 0.75)) {
                cellOpacity = 1.0
            }
        }
    }

}

extension EntryViewCell {
    func getDominantColorFromImage(urlString: String) async throws {
        
        //reference : https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
        
        //get image from remote
        guard let imageURL = URL(string: urlString) else { return }
        let imageAsData = try await URLSession.shared.data(from: imageURL).0
        
        //calculate dominant color via ColorKit
//        guard let targetImage: UIImage = UIImage(data: imageAsData) else { return }
//        let dominantColors: [UIColor] = try targetImage.dominantColors()
//        backgroundColor = dominantColors[0]
        
        //calculate dominant color via CIFilter
        guard let targetImage: CIImage = CIImage(data: imageAsData) else { return }
        
        let extentVector: CIVector = CIVector(x: targetImage.extent.minX,
                                              y: targetImage.extent.minY,
                                              z: targetImage.extent.width,
                                              w: targetImage.extent.height)
        guard let filter: CIFilter = CIFilter(name: "CIAreaAverage",
                                              parameters: [kCIInputImageKey: targetImage,
                                                          kCIInputExtentKey: extentVector]) else { return }
        guard let outputImage = filter.outputImage else { return }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, 
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)
        backgroundColor = UIColor(red: CGFloat(bitmap[0]) / 25.5,
                                  green: CGFloat(bitmap[1]) / 25.5,
                                  blue: CGFloat(bitmap[2]) / 25.5,
                                  alpha: 1)
        //CGFloat(bitmap[3]) / 255
//        print(backgroundColor)
    }
}

#Preview {
    EntryViewCell(index: 24, pokemonName: "Pikachu")
        .frame(height: 140)
}
