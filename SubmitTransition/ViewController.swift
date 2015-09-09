import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var btn: TKTransitionSubmitButton!

    @IBOutlet weak var btnFromNib: TKTransitionSubmitButton!
    
    var success = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        let bg = UIImageView(image: UIImage(named: "Login"))
        bg.frame = self.view.frame
        self.view.addSubview(bg)

        btn = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 64, height: 44))
        btn.center = self.view.center
        btn.frame.bottom = self.view.frame.height - 60
        btn.setTitle("Sign in", forState: .Normal)
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        btn.addTarget(self, action: "onTapButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)

        self.view.bringSubviewToFront(self.btnFromNib)
    }

    @IBAction func onTapButton(button: TKTransitionSubmitButton) {

        if success {
            button.startAnimate()
            button.transitionDuration = 2.0
            NSTimer.schedule(delay: 1, handler: { (timer) -> Void in
                self.ts_presentViewController(SecondViewController(), fromButton: button, animated: true, completion: nil)
            })

        }else{
            button.startAnimate()
            NSTimer.schedule(delay: 1, handler: { (timer) -> Void in
                button.stopAnimate()
            })
        }
        
        success = !success
    }
}

