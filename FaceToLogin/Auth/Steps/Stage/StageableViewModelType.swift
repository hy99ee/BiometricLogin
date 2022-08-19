import Foundation

protocol StageableVieModel: ObservableObject {
    var stage: StageType { get set }

    associatedtype StageType: Stage, Equatable
    func start(with stage: StageType) -> Self
}

extension StageableVieModel {
    func start(with stage: StageType) -> Self {
        if self.stage != stage { self.stage = stage }
        return self
    }
}
