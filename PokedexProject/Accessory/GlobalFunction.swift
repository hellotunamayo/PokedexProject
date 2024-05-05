//
//  GlobalFunction.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/27/24.
//

import SwiftUI

func getColorFromImage(urlString: String) async throws -> UIColor {
    
    //reference : https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
    
    //get image from remote
    guard let imageURL = URL(string: urlString) else { return UIColor() }
    let imageAsData = try await URLSession.shared.data(from: imageURL).0
    
    //calculate dominant color via ColorKit
    //        guard let targetImage: UIImage = UIImage(data: imageAsData) else { return }
    //        let dominantColors: [UIColor] = try targetImage.dominantColors()
    //        backgroundColor = dominantColors[0]
    
    //calculate dominant color via CIFilter
    guard let targetImage: CIImage = CIImage(data: imageAsData) else { return UIColor() }
    
    let extentVector: CIVector = CIVector(x: targetImage.extent.minX,
                                          y: targetImage.extent.minY,
                                          z: targetImage.extent.width,
                                          w: targetImage.extent.height)
    guard let filter: CIFilter = CIFilter(name: "CIAreaAverage",
                                          parameters: [kCIInputImageKey: targetImage,
                                                      kCIInputExtentKey: extentVector]) else { return UIColor() }
    guard let outputImage = filter.outputImage else { return UIColor() }
    var bitmap = [UInt8](repeating: 0, count: 4)
    let context = CIContext(options: [.workingColorSpace: kCFNull!])
    context.render(outputImage,
                   toBitmap: &bitmap,
                   rowBytes: 4,
                   bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                   format: .RGBA8,
                   colorSpace: nil)
    let redColor: CGFloat = CGFloat(bitmap[0]) / 25.5
    let greenColor: CGFloat = CGFloat(bitmap[1]) / 25.5
    let blueColor: CGFloat = CGFloat(bitmap[2]) / 25.5
    return UIColor(red: redColor > 1.0 ? 1.0 : redColor,
                   green: greenColor > 1.0 ? 1.0 : greenColor,
                   blue: blueColor > 1.0 ? 1.0 : blueColor,
                   alpha: 1)
    //CGFloat(bitmap[3]) / 255
}

/// 포켓몬 타입 별 아이콘과 타입 별 색상을 튜플로 리턴
func getPokemonTypeImageAndColor(type: String) -> (typeIconName: String, typeColor: UIColor) {
    
    switch type {
        case "normal":
            return (type, UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
        case "bug":
            return (type, UIColor(red: 132/255, green: 177/255, blue: 20/255, alpha: 1))
        case "dark":
            return (type, UIColor(red: 71/255, green: 69/255, blue: 79/255, alpha: 1))
        case "dragon":
            return (type, UIColor(red: 17/255, green: 85/255, blue: 190/255, alpha: 1))
        case "electric":
            return (type, UIColor(red: 250/255, green: 170/255, blue: 51/255, alpha: 1))
        case "fairy":
            return (type, UIColor(red: 228/255, green: 120/255, blue: 226/255, alpha: 1))
        case "fighting":
            return (type, UIColor(red: 194/255, green: 42/255, blue: 77/255, alpha: 1))
        case "fire":
            return (type, UIColor(red: 245/255, green: 17/255, blue: 54/255, alpha: 1))
        case "flying":
            return (type, UIColor(red: 145/255, green: 173/255, blue: 233/255, alpha: 1))
        case "ghost":
            return (type, UIColor(red: 76/255, green: 88/255, blue: 177/255, alpha: 1))
        case "grass":
            return (type, UIColor(red: 88/255, green: 179/255, blue: 64/255, alpha: 1))
        case "ground":
            return (type, UIColor(red: 189/255, green: 174/255, blue: 117/255, alpha: 1))
        case "ice":
            return (type, UIColor(red: 107/255, green: 200/255, blue: 180/255, alpha: 1))
        case "poison":
            return (type, UIColor(red: 163/255, green: 74/255, blue: 199/255, alpha: 1))
        case "psychic":
            return (type, UIColor(red: 143/255, green: 145/255, blue: 141/255, alpha: 1))
        case "rock":
            return (type, UIColor(red: 204/255, green: 102/255, blue: 58/255, alpha: 1))
        case "steel":
            return (type, UIColor(red: 74/255, green: 132/255, blue: 146/255, alpha: 1))
        case "water":
            return (type, UIColor(red: 71/255, green: 139/255, blue: 218/255, alpha: 1))
        default:
            return (type, UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
    }
    }
