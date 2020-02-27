# iStyle
an application of Style Transfer on iOS
* based on CNN
* Mask R-CNN for selecting people/background automatically
* 10 default styles or customized style

## Demo
{%youtube KYqbE8JfhjY %}

## Motivation
What would happen if we combine two or even more images?
![](https://i.imgur.com/A7quaWh.png)

## Structure
![](https://i.imgur.com/ZFTWCac.png)

## Techniques
### Johnson’s Model
for 10 default pre-train models
![](https://i.imgur.com/iVZ8WfZ.png)

### AdaIN
for customized style
![](https://i.imgur.com/rmnLdis.png)

### Mask R-CNN
![](https://i.imgur.com/AnUgBPj.png)

![](https://i.imgur.com/O7VrVwA.png)

![](https://i.imgur.com/jr0JkFI.jpg)

## References
Style Transfer
* [Perceptual Losses for Real-Time Style Transfer and Super-Resolution](https://arxiv.org/abs/1603.08155)
Justin Johnson, Alexandre Alahi, Li Fei-Fei
* [Arbitrary Style Transfer in Real-time with Adaptive Instance Normalization](https://arxiv.org/abs/1703.06868)
Xun Huang, Serge Belongie

Object Segmentation
* [Mask R-CNN](https://arxiv.org/abs/1703.06870)
Kaiming He, Georgia Gkioxari, Piotr Dollár, Ross Girshick
