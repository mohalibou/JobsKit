//
//  TeamID.swift
//  JobsKit
//

/// Identifies a team, such as `teamsAndSubTeams-SFTWR`.
public struct TeamID: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension TeamID {
    public static let machineLearningAndAI = TeamID(rawValue: "teamsAndSubTeams-MLAI")
    public static let hardware = TeamID(rawValue: "teamsAndSubTeams-HRDWR")
    public static let softwareAndServices = TeamID(rawValue: "teamsAndSubTeams-SFTWR")
    public static let design = TeamID(rawValue: "teamsAndSubTeams-DESGN")
    public static let operationsAndSupplyChain = TeamID(rawValue: "teamsAndSubTeams-OPMFG")
    public static let marketing = TeamID(rawValue: "teamsAndSubTeams-MKTG")
    public static let corporateFunctions = TeamID(rawValue: "teamsAndSubTeams-CORSV")
    public static let appleRetail = TeamID(rawValue: "teamsAndSubTeams-APPST")
    public static let salesAndBusinessDevelopment = TeamID(rawValue: "teamsAndSubTeams-SLDEV")
    public static let supportAndService = TeamID(rawValue: "teamsAndSubTeams-CUST")
    public static let students = TeamID(rawValue: "teamsAndSubTeams-STDNT")
}
