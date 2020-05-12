//
//  ViewController.swift
//  Image3d
//
//  Created by MohammadAkbari on 12/05/2020.
//  Copyright © 2020 MohammadAkbari. All rights reserved.
//

import UIKit
import LBTATools
import RxGesture
import RxSwift


class ViewController: UIViewController {

    var angle = CGPoint.init(x: 0, y: 0)
    
    // view for inside 3d rotate
    let diceView = UIView()
    
    //back image
    private var stepBag = DisposeBag()

    let imageView = UIImageView(image: #imageLiteral(resourceName: "one"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for handel 3d for view
        let panGes = UIPanGestureRecognizer.init(target: self, action: #selector(viewTransform))
        diceView.addGestureRecognizer(panGes)
        addDice()
        
        
        // rx ges for fix touch change location
        let rotationGesture = diceView.rx
            .rotationGesture()
            .share(replay: 1)

        rotationGesture
            .when(.changed)
            .asRotation()
            .subscribe(onNext: { rotation, point in
                self.diceView.transform = CGAffineTransform(rotationAngle: rotation)
            })
            .disposed(by: stepBag)

        }

}

extension ViewController {
    fileprivate func addDice() {
        
        
        
        
       //  image inside dic view show
        let dice1 = UIImageView.init(image: UIImage.init(named: "new"))
    
        
        
        // add view
        diceView.addSubview(dice1)

        view.addSubview(imageView)
        view.addSubview(diceView)
        
        
        // set view aligin
        imageView.fillSuperview()
        diceView.centerInSuperview(size: .init(width: view.frame.width - 30, height: 400))
        
        dice1.fillSuperview()
    }
}


extension ViewController {
    
    // handeling 3DRotate
    @objc fileprivate func viewTransform(sender : UIPanGestureRecognizer) {
        
        let point = sender.translation(in: diceView)
        let angleX = self.angle.x + (point.x / 100)
        let angleY = self.angle.y - (point.y / 100)
        
        var transform = CATransform3DIdentity
        
        transform.m34 = -1 / 400
        transform = CATransform3DRotate(transform, angleX, 0, 1, 0)
        transform = CATransform3DRotate(transform, angleY, 1, 0, 0)
        
        diceView.layer.sublayerTransform = transform
        
        if sender.state == .recognized {
            self.angle.x = angleX
            self.angle.y = angleY
        }
    }
}


