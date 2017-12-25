//
//  WaveActiveView.swift
//  CaveAndLine
//
//  Created by Eleven on 2017/11/13.
//  Copyright © 2017年 Eleven. All rights reserved.
//

import UIKit

class WaveActiveView: UIView {
    var waveSpeed:CGFloat = 0
    var waveAmplitude:CGFloat = 0
    var waveColor:UIColor!
    var persentScale:CGFloat = 0
    var waterWaveHeight:CGFloat = 0
    var waterWaveWidth:CGFloat = 0
    var offsetX:CGFloat = 0
    var currentWavePointY:CGFloat = 0
    var waveGrowth:CGFloat = 0
    var waveDisplaylink:CADisplayLink!
    var waveLayer:CAShapeLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        waterWaveHeight = frame.size.height / 2
        waterWaveWidth = frame.size.width
        waveAmplitude = 6
        waveSpeed = 6
        waveColor = UIColor.cyan
        waveGrowth = 0.85
        self.resetProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetProperty() {
        currentWavePointY = 10
    }

    func setPersent(persent:CGFloat) {
        persentScale = persent
    }

    func wave() {
        waveLayer = CAShapeLayer.init()
        waveLayer.fillColor = waveColor.cgColor
        self.layer.addSublayer(waveLayer)
        waveDisplaylink = CADisplayLink.init(target: self, selector: #selector(getCurrentWave(displayLink:)))
        waveDisplaylink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }

    @objc func getCurrentWave(displayLink:CADisplayLink){
        if waveGrowth < 0 && currentWavePointY > 2 * waterWaveHeight * (1 - persentScale) {
            currentWavePointY += waveGrowth
        }else if  (waveGrowth > 0 && currentWavePointY < 2 * waterWaveHeight * (1 - persentScale)){
            currentWavePointY += waveGrowth
        }

        offsetX += waveSpeed
        let path:CGPath = self.getCurrentWavePath()
        waveLayer.path = path
    }

    func stop() {
        waveLayer.removeFromSuperlayer()
        waveDisplaylink.invalidate()
        waveDisplaylink = nil
    }

    func getCurrentWavePath() -> (CGPath) {
        let mutablePath = CGMutablePath.init()
        mutablePath.move(to: CGPoint.init(x: 0, y: currentWavePointY))
        var y:CGFloat = 0.0
        let forIntWidth:Int = Int(waterWaveWidth)
        for x:Int in 0 ..< forIntWidth {
            let Fx:CGFloat = CGFloat(x)
            let ratio = (360 / waterWaveWidth) * (Fx * CGFloat.pi / 180)
            let rxt = offsetX * CGFloat.pi / 180
            let sinw = sinf(Float(ratio - rxt))
            y = waveAmplitude * CGFloat(sinw) - currentWavePointY
            mutablePath.addLine(to: CGPoint.init(x: Fx, y: -y))
        }
        mutablePath.addLine(to: CGPoint.init(x: waterWaveWidth, y: self.frame.size.height))
        mutablePath.addLine(to: CGPoint.init(x: 0, y: self.frame.size.height))
        mutablePath.closeSubpath()
        return mutablePath
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
