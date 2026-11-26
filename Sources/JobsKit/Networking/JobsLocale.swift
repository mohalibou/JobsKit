//
//  JobsLocale.swift
//  JobsKit
//

import Foundation

/// A language and region that Apple publishes its jobs site in.
///
/// Apple identifies a locale in two ways, and one can't be derived from the other:
/// the United Kingdom is `en-gb` and `en_UK`, and Poland is `pl-pl` and `en_UK`.
public struct JobsLocale: Hashable, Sendable {
    /// Used by search and job details, such as `en-us`.
    let site: String
    
    /// Used by headers, locations, and stores, such as `en_US`.
    let data: String
}

// MARK: - Matching

extension JobsLocale {
    
    /// The locale for a site identifier, such as `en-us`. Ignores case.
    public init?(identifier: String) {
        let identifier = identifier.lowercased().replacingOccurrences(of: "_", with: "-")
        guard let locale = Self.all.first(where: { $0.site == identifier }) else { return nil }
        self = locale
    }
    
    /// The site identifier, such as `en-us`.
    public var identifier: String {
        site
    }
}

// MARK: - Locales

extension JobsLocale {
    
    public static let arSA = JobsLocale(site: "ar-sa", data: "ar_SA")
    public static let csCZ = JobsLocale(site: "cs-cz", data: "en_UK")
    public static let daDK = JobsLocale(site: "da-dk", data: "en_UK")
    public static let deAT = JobsLocale(site: "de-at", data: "de_AT")
    public static let deCH = JobsLocale(site: "de-ch", data: "de_CH")
    public static let deDE = JobsLocale(site: "de-de", data: "de_DE")
    public static let enAE = JobsLocale(site: "en-ae", data: "en_US")
    public static let enAU = JobsLocale(site: "en-au", data: "en_UK")
    public static let enCA = JobsLocale(site: "en-ca", data: "en_US")
    public static let enEG = JobsLocale(site: "en-eg", data: "en_UK")
    public static let enGB = JobsLocale(site: "en-gb", data: "en_UK")
    public static let enGR = JobsLocale(site: "en-gr", data: "en_UK")
    public static let enHK = JobsLocale(site: "en-hk", data: "en_UK")
    public static let enIE = JobsLocale(site: "en-ie", data: "en_UK")
    public static let enIL = JobsLocale(site: "en-il", data: "en_US")
    public static let enIN = JobsLocale(site: "en-in", data: "en_UK")
    public static let enMO = JobsLocale(site: "en-mo", data: "en_UK")
    public static let enMY = JobsLocale(site: "en-my", data: "en_UK")
    public static let enNG = JobsLocale(site: "en-ng", data: "en_UK")
    public static let enNZ = JobsLocale(site: "en-nz", data: "en_UK")
    public static let enRO = JobsLocale(site: "en-ro", data: "en_UK")
    public static let enSA = JobsLocale(site: "en-sa", data: "en_SA")
    public static let enSG = JobsLocale(site: "en-sg", data: "en_UK")
    public static let enUA = JobsLocale(site: "en-ua", data: "en_UK")
    public static let enUS = JobsLocale(site: "en-us", data: "en_US")
    public static let esCL = JobsLocale(site: "es-cl", data: "en_US")
    public static let esCO = JobsLocale(site: "es-co", data: "en_US")
    public static let esES = JobsLocale(site: "es-es", data: "es_ES")
    public static let esMX = JobsLocale(site: "es-mx", data: "es_MX")
    public static let fiFI = JobsLocale(site: "fi-fi", data: "en_UK")
    public static let frBE = JobsLocale(site: "fr-be", data: "fr_BE")
    public static let frCA = JobsLocale(site: "fr-ca", data: "fr_CA")
    public static let frCH = JobsLocale(site: "fr-ch", data: "fr_CH")
    public static let frFR = JobsLocale(site: "fr-fr", data: "fr_FR")
    public static let huHU = JobsLocale(site: "hu-hu", data: "en_UK")
    public static let itIT = JobsLocale(site: "it-it", data: "it_IT")
    public static let jaJP = JobsLocale(site: "ja-jp", data: "ja_JP")
    public static let koKR = JobsLocale(site: "ko-kr", data: "ko_KR")
    public static let nlBE = JobsLocale(site: "nl-be", data: "nl_BE")
    public static let nlNL = JobsLocale(site: "nl-nl", data: "nl_NL")
    public static let noNO = JobsLocale(site: "no-no", data: "en_UK")
    public static let plPL = JobsLocale(site: "pl-pl", data: "en_UK")
    public static let ptBR = JobsLocale(site: "pt-br", data: "pt_BR")
    public static let ptPT = JobsLocale(site: "pt-pt", data: "en_UK")
    public static let roRO = JobsLocale(site: "ro-ro", data: "en_UK")
    public static let svSE = JobsLocale(site: "sv-se", data: "sv_SE")
    public static let thTH = JobsLocale(site: "th-th", data: "th_TH")
    public static let trTR = JobsLocale(site: "tr-tr", data: "tr_TR")
    public static let zhCN = JobsLocale(site: "zh-cn", data: "zh_CN")
    public static let zhHK = JobsLocale(site: "zh-hk", data: "zh_HK")
    public static let zhMO = JobsLocale(site: "zh-mo", data: "zh_HK")
    public static let zhTW = JobsLocale(site: "zh-tw", data: "zh_TW")
    
    /// Every locale Apple listed on November 24, 2026.
    public static let all: [JobsLocale] = [
        .arSA, .csCZ, .daDK, .deAT, .deCH, .deDE,
        .enAE, .enAU, .enCA, .enEG, .enGB, .enGR,
        .enHK, .enIE, .enIL, .enIN, .enMO, .enMY,
        .enNG, .enNZ, .enRO, .enSA, .enSG, .enUA,
        .enUS, .esCL, .esCO, .esES, .esMX, .fiFI,
        .frBE, .frCA, .frCH, .frFR, .huHU, .itIT,
        .jaJP, .koKR, .nlBE, .nlNL, .noNO, .plPL,
        .ptBR, .ptPT, .roRO, .svSE, .thTH, .trTR,
        .zhCN, .zhHK, .zhMO, .zhTW,
    ]
}
