//
//  LoginTheme.swift
//  MSLoginKit
//
//  Created by mohammed Shafiullah on 05/10/25.
//
import SwiftUI

public struct LoginTheme {
    public var primaryColor: Color
    public var secondaryColor: Color
    public var buttonCornerRadius: CGFloat
    public var font: Font

    public init(primaryColor: Color = .blue,
                secondaryColor: Color = .gray,
                buttonCornerRadius: CGFloat = 8,
                font: Font = .body) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.buttonCornerRadius = buttonCornerRadius
        self.font = font
    }
}
