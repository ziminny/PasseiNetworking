//
//  SwiftUIView.swift
//
//
//  Created by Vagner Oliveira on 11/06/23.
//

import SwiftUI

#if os(macOS)
/// Modelo vazio que herda de NSModel.
public class NSEmptyModel: NSModel {
    
    public static var supportsSecureCoding: Bool { true }
    
    public func encode(with coder: NSCoder) { }
    
    public required init?(coder: NSCoder) { }
    
}
#else
/// Modelo vazio que herda de NSModel.
public final class NSEmptyModel: NSModel {
    // Implementação do modelo vazio. Pode ser estendido conforme necessário por padrao vem {}.
}
#endif

