    func dispatch(_ action: AppAction) {
        handleMaskCreation(action)
        state = reducer.reduce(state, action)
    }
    
    private func handleMaskCreation(_ action: AppAction) {
        guard case .changeCollage(.changeShape(let action, id: let id)) = action,
              case .changeMedia(.changeMask(.createMask(let image))) = action else {
            return
        }
        
        Task { @MainActor in
            if let maskImage = try? await backgroundRemoval.crateMask(for: image) {
                dispatch(.changeCollage(.changeShape(
                    .changeMedia(.changeMask(.change(maskImage))),
                    id: id
                )))
            }
        }
    }
    
}
