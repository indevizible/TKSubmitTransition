import Foundation
import UIKit

let PINK = UIColor(red:0.992157, green: 0.215686, blue: 0.403922, alpha: 1)
let DARK_PINK = UIColor(red:0.798012, green: 0.171076, blue: 0.321758, alpha: 1)

@IBDesignable
public class TKTransitionSubmitButton : UIButton, UIViewControllerTransitioningDelegate {
    
    public var didEndFinishAnimation : (()->())? = nil

    let springGoEase = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    let shrinkCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    let shrinkDuration: CFTimeInterval  = 0.1

    lazy var spiner: SpinerLayer! = {
        let s = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(s)
        return s
    }()

    @IBInspectable public var highlightedBackgroundColor: UIColor? = DARK_PINK {
        didSet {
            self.setBackgroundColor()
        }
    }
    
    @IBInspectable public var normalBackgroundColor: UIColor? = PINK {
        didSet {
            self.setBackgroundColor()
        }
    }
    
    @IBInspectable public var transitionDuration = 1.0
    
    var cachedTitle: String?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    override public var highlighted: Bool {
        didSet {
            self.setBackgroundColor()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.setBackgroundColor()
    }

    func setBackgroundColor() {
        if (highlighted) {
            self.backgroundColor = highlightedBackgroundColor
        }
        else {
            self.backgroundColor = normalBackgroundColor
        }
    }

    func startLoadingAnimation() {
        if self.enabled {
            self.cachedTitle = titleForState(.Normal)
            self.setTitle("", forState: .Normal)
            self.shrink()
            NSTimer.schedule(delay: shrinkDuration - 0.25) { timer in
                self.spiner.animation()
            }
            self.enabled = false
        }
    }

    public func startFinishAnimation(delay: NSTimeInterval, completion:(()->())?) {
        NSTimer.schedule(delay: delay) { timer in
            self.didEndFinishAnimation = completion
//            self.expand()
            self.cancelShrink()
            self.setTitle(self.cachedTitle, forState: .Normal)
            self.spiner.stopAnimation()
            self.enabled = true
        }
    }
    
    public func startAnimate(){
        if self.enabled {
            startLoadingAnimation()
        }
    }
    
    public func stopAnimate(){
        self.cancelShrink()
        self.setTitle(self.cachedTitle, forState: .Normal)
        self.spiner.stopAnimation()
        self.enabled = true
    }

    public func animate(duration: NSTimeInterval, completion:(()->())?) {
        if self.enabled {
            startLoadingAnimation()
            startFinishAnimation(duration, completion: completion)
        }
    }

    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let a = anim as! CABasicAnimation
        if a.keyPath == "transform.scale" {
            didEndFinishAnimation?()
            NSTimer.schedule(delay: 1) { timer in
                self.returnToOriginalState()
            }
        }
    }
    
    func returnToOriginalState() {
        self.layer.removeAllAnimations()
        self.setTitle(self.cachedTitle, forState: .Normal)
    }
    
    func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.removedOnCompletion = false
        layer.addAnimation(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    public func cancelShrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.height
        shrinkAnim.toValue = frame.width
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.removedOnCompletion = false
        layer.addAnimation(shrinkAnim, forKey: shrinkAnim.keyPath)
        NSTimer.schedule(delay: shrinkDuration) { timer in
            self.returnToOriginalState()
        }
    }
    
    func expand() {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 26.0
        expandAnim.timingFunction = expandCurve
        expandAnim.duration = 0.3
        expandAnim.delegate = self
        expandAnim.fillMode = kCAFillModeForwards
        expandAnim.removedOnCompletion = false
        layer.addAnimation(expandAnim, forKey: expandAnim.keyPath)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
     public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: transitionDuration, startingAlpha: 0)
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}

extension UIViewController {
    public func ts_presentViewController(viewController:UIViewController, fromButton:TKTransitionSubmitButton, animated:Bool, completion:(()->Void)?){
        viewController.transitioningDelegate = fromButton
        fromButton.enabled = true
        fromButton.spiner.stopAnimation()
        fromButton.expand()
        presentViewController(viewController, animated: animated, completion: completion)
        NSTimer.schedule(delay: fromButton.transitionDuration) { (timer) -> Void in
            fromButton.returnToOriginalState()
        }
    }
}
