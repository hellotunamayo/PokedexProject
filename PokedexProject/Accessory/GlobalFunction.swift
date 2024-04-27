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
