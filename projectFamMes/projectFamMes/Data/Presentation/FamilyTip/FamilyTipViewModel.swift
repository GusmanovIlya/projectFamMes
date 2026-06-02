import Foundation
import Observation

@MainActor
@Observable
final class FamilyTipViewModel {
    private let service: any FamilyTipService
    private var hasLoaded = false

    var tip: FamilyTip?
    var state: ViewState = .loading

    init(service: any FamilyTipService) {
        self.service = service
    }

    func loadTipIfNeeded() async {
        guard !hasLoaded else { return }

        hasLoaded = true
        await loadTip()
    }

    func loadTip() async {
        state = .loading

        do {
            tip = try await service.fetchDailyTip()
            state = .content
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
