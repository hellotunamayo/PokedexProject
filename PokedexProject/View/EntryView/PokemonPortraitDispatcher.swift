//
//  PokemonPortraitDispatcher.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/29/24.
//

import SwiftUI
import Combine

final class PokemonPortraitDispatcher: ObservableObject {
    @Published private(set) var backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    @Published private(set) var image: UIImage?
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    private var cancellable: AnyCancellable?
    
    func load(with imageUrlString: String) {
        guard let imageUrl = URL(string: imageUrlString) else {
            debugPrint("fail with bad url")
            return
        }
        self.cancellable = session.dataTaskPublisher(for: imageUrl)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HttpError.badResponse
                }
                guard httpResponse.statusCode == 200 else {
                    throw HttpError.errorWith(code: httpResponse.statusCode, data: data)
                }

                return data
            }
            .map(combineImageAndColor(from:))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        debugPrint(error)
                }
            } receiveValue: { [weak self] color, image in
                self?.backgroundColor = color
                self?.image = image
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func combineImageAndColor(from imageData: Data) -> (UIColor, UIImage) {
        let color = extractImageColor(from: imageData)
        let image = UIImage(data: imageData) ?? UIImage()
        
        return (color, image)
    }
    
    private func extractImageColor(from imageData: Data) -> UIColor {
        guard let targetImage = CIImage(data: imageData) else { return UIColor() }
        
        let extentVector = CIVector(
            x: targetImage.extent.minX,
            y: targetImage.extent.minY,
            z: targetImage.extent.width,
            w: targetImage.extent.height
        )
        guard let filter = CIFilter(
            name: "CIAreaAverage",
            parameters: [
                kCIInputImageKey: targetImage,
                kCIInputExtentKey: extentVector
            ]
        ) else {
            return UIColor()
        }
        
        guard let outputImage = filter.outputImage else { return UIColor() }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )
        
        let redColor: CGFloat = CGFloat(bitmap[0]) / 25.5
        let greenColor: CGFloat = CGFloat(bitmap[1]) / 25.5
        let blueColor: CGFloat = CGFloat(bitmap[2]) / 25.5
        return UIColor(
            red: redColor > 1.0 ? 1.0 : redColor,
            green: greenColor > 1.0 ? 1.0 : greenColor,
            blue: blueColor > 1.0 ? 1.0 : blueColor,
            alpha: 1
        )
    }
}
