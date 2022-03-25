import UIKit

final class CustomBlurEffectView: UIVisualEffectView {
    private let style: UIBlurEffect.Style
    private let intensivity: CGFloat
    private var animator: UIViewPropertyAnimator?
    
    init(style: UIBlurEffect.Style = .systemUltraThinMaterial, intensity: CGFloat) {
        self.style = style
        self.intensivity = intensity
        super.init(effect: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }

    override func draw(_ rect: CGRect) {
      super.draw(rect)
      effect = nil
      animator?.stopAnimation(true)
      animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
          guard let self = self else { return }
          let effect = UIBlurEffect(style: self.style)
          self.effect = effect
      }
      animator?.fractionComplete = intensivity
    }
    
    
    deinit {
      animator?.stopAnimation(true)
    }
}
