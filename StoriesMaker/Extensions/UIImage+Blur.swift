//
//  UIImage+Blur.swift
//  PlantsApp
//
//  Created by Anton Mitrafanau on 22/08/2023.
//

import Accelerate
import UIKit

extension UIImage {
    
    // MARK: - Types
    
    private struct BlurComponents {
        
        /// Blur Radius. Mutable proeprty, feel free to change it
        static let GAUSIAN_TO_TENT_RADIUS_RADIO: Float = 8.0
        
        static func arg888format() -> vImage_CGImageFormat {
            return vImage_CGImageFormat(
                bitsPerComponent: 8,
                bitsPerPixel: 32,
                colorSpace: nil,
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue),
                version: 0,
                decode: nil,
                renderingIntent: .defaultIntent
            )
        }
    }
    
    // MARK: - Public Methods
    
    func applyGaussianBlur(radius: Float) -> UIImage {
        assert(radius > 0)
        guard let sourceCgImage = cgImage else { return self }
        
        guard var srcBuffer = createBuffer(sourceImage: sourceCgImage) else { return self }
        let pixelBuffer = malloc(srcBuffer.rowBytes * Int(srcBuffer.height))
        defer { free(pixelBuffer) }
        
        var outputBuffer = vImage_Buffer(
            data: pixelBuffer,
            height: srcBuffer.height,
            width: srcBuffer.width,
            rowBytes: srcBuffer.rowBytes
        )
        
        var boxSize = UInt32(floor(radius * BlurComponents.GAUSIAN_TO_TENT_RADIUS_RADIO))
        boxSize |= 1
        
        let error = vImageTentConvolve_ARGB8888(
            &srcBuffer,
            &outputBuffer,
            nil,
            0, 0,
            boxSize,
            boxSize,
            nil,
            UInt32(kvImageEdgeExtend)
        )
        
        guard error == vImage_Error(kvImageNoError) else { return self }
        
        var format = BlurComponents.arg888format()
        guard
            let cgResult = vImageCreateCGImageFromBuffer(
                &outputBuffer,
                &format,
                nil,
                nil,
                vImage_Flags(kvImageNoFlags),
                nil)
        else { return self }
        
        let result = UIImage(
            cgImage: cgResult.takeRetainedValue(),
            scale: scale,
            orientation: imageOrientation)
        
        return result
    }
    
    // MARK: - Private Methods
    
    private func createBuffer(sourceImage: CGImage) -> vImage_Buffer? {
        var srcBuffer = vImage_Buffer()
        
        var format = BlurComponents.arg888format()
        let error = vImageBuffer_InitWithCGImage(&srcBuffer, &format, nil, sourceImage, vImage_Flags(kvImageNoFlags))
        
        guard error == vImage_Error(kvImageNoError) else { free(srcBuffer.data); return nil }
        return srcBuffer
    }
}
