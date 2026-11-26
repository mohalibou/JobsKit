//
//  ProductID.swift
//  JobsKit
//

/// Identifies a product or service, such as `productsAndServices-SIRI`.
public struct ProductID: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension ProductID {
    public static let appleAds = ProductID(rawValue: "productsAndServices-IAD")
    public static let airPods = ProductID(rawValue: "productsAndServices-AIRPD")
    public static let appleAccessories = ProductID(rawValue: "productsAndServices-APPAS")
    public static let appleCare = ProductID(rawValue: "productsAndServices-APPAC")
    public static let appleMusic = ProductID(rawValue: "productsAndServices-APPMU")
    public static let applePay = ProductID(rawValue: "productsAndServices-APPAY")
    public static let appleRetailStore = ProductID(rawValue: "productsAndServices-APRTS")
    public static let appleTV = ProductID(rawValue: "productsAndServices-APPTV")
    public static let appleOnlineStore = ProductID(rawValue: "productsAndServices-AWB")
    public static let appleVisionPro = ProductID(rawValue: "productsAndServices-AVPRO")
    public static let appleWatch = ProductID(rawValue: "productsAndServices-APPWT")
    public static let appStore = ProductID(rawValue: "productsAndServices-APPST")
    public static let beatsAudioAccessories = ProductID(rawValue: "productsAndServices-BTSAA")
    public static let consumerAndProApps = ProductID(rawValue: "productsAndServices-CONPRO")
    public static let claris = ProductID(rawValue: "productsAndServices-FM")
    public static let homePod = ProductID(rawValue: "productsAndServices-HMPD")
    public static let iCloud = ProductID(rawValue: "productsAndServices-ICLD")
    public static let iOS = ProductID(rawValue: "productsAndServices-IOS")
    public static let iPad = ProductID(rawValue: "productsAndServices-IPAD")
    public static let iPhone = ProductID(rawValue: "productsAndServices-IPHN")
    public static let iPod = ProductID(rawValue: "productsAndServices-IPOD")
    public static let iTunes = ProductID(rawValue: "productsAndServices-ITUNS")
    public static let mac = ProductID(rawValue: "productsAndServices-MAC")
    public static let macOS = ProductID(rawValue: "productsAndServices-MACOS")
    public static let maps = ProductID(rawValue: "productsAndServices-MAPS")
    public static let news = ProductID(rawValue: "productsAndServices-NEWS")
    public static let siri = ProductID(rawValue: "productsAndServices-SIRI")
    public static let tvOS = ProductID(rawValue: "productsAndServices-TVOS")
    public static let visionOS = ProductID(rawValue: "productsAndServices-VISOS")
    public static let watchOS = ProductID(rawValue: "productsAndServices-WTOS")
    public static let other = ProductID(rawValue: "productsAndServices-OTH")
}
