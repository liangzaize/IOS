# 《显卡佬》---IOS客户端调试日志
[![Build Status](https://travis-ci.org/liangzaize/IOS.svg?branch=master)](https://travis-ci.org/liangzaize/IOS)
![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg?style=flat)
![Xcode 8.2](https://img.shields.io/badge/Xcode-8.2-blue.svg?style=flat)
![email lichhero620@gmail.com](https://img.shields.io/badge/email-lichhero620@gmail.com-yellow.svg?style=flat)
####程序介绍
-《显卡佬》主要的服务领域在计算机硬件，本软件集成了包括各类电脑硬件的参数、电脑硬件方面新闻、用户论坛等功能，用户可以在程序中看到所有电脑硬件比如显卡、CPU等的参数，并且可以浏览最新的与电脑有关的新闻。
[跳至Java服务端仓库](https://github.com/liangzaize/Java)
---
###21/Jan/2017
完成了帖子正文的顶楼部分，但是内容的uitextview还未能随着内容改变高度
###18/Jan/2017
完成提交帖子的功能
###16/Jan/2017
重新设计了发帖子的用户界面，之前的太丑了
###14/Jan/2017
增加了新的界面，用户发送自己的帖子
###13/Jan/2017
新增论坛基本列表功能
###12/Jan/2017
增加新闻列表上拉添加新闻的功能，每一次显示10条新闻
###11/Jan/2017
修正原有的新闻功能旧代码，与新服务端进行对接，实现新闻的简要界面（图片、标题、摘要）和具体内容与jsp对接
###6/Jan/2017
新增更换头像图片功能，用户登录后在头像下方会出现一个更换头像的button，点击可以选择拍照或者在本地提取相片，然后把图片压缩大小后编码成base64发送给服务端
###5/Jan/2017
调整了注册/登录大量的逻辑，可以往前回传数据了，注册/登录功能已完成基本功能
###3/Jan/2017
个人的注册登录可以正常的接发了，但是注册成功了不能正常把数据传给前一页，出现nil的问题，尚不明确哪里出的问题
###2/Jan/2017
完成硬件参数显示的所有功能，修复了所有的BUG，目前已完成显卡部分的内容，只剩下填补完整其它内容
###1/Jan/2017
服务端语言由golang改回java，重新修改与服务端对接的代码，增进了一些自动构造功能，减少弱鸡的固定显示
###18/Dec/2016
初始化该github，做了一些UI的交互
