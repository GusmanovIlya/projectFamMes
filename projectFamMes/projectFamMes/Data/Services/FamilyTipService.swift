import Foundation

protocol FamilyTipService {
    func fetchDailyTip() async throws -> FamilyTip
}
