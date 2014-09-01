---
layout: default
---

### 项目发起原因

Macx.cn是我很一直都喜欢的一个网站，上面有很多的免费或破解的软件可以使用。最近推出了自己的客户端软件。我简单的分析了一下，这个客户端使用的是Swift开发，利用soft.macx.cn提供的接口实现的功能。软件可以方便我们搜索和管理自己的软件，但是在功能和界面的设计上都差强人意。所以我使用Objective-C重新开发了一个开源版本。使用的是同样的接口提供数据。

目前项目还处于开发阶段，很多功能还需要重构和完善，大家有什么需求和建议可以积极提出来。有兴趣的童鞋可以一起参与开发。

### Macx提供的接口

Macx提供软件相关的接口地址为http://soft.macx.cn， 提供新闻相关的接口是http://macx.cn。

**注意** Macx提供的接口是我通过抓包获取，很有可能随时变化，需要关注这一点。

#### 软件总数，可以用于进度条显示

    req> GET /number.asp

    res> number

#### 软件列表，软件详细信息的列表

    req> GET /xml.asp?id=soft&no=20&order=total

    res> text/xml

#### 软件点赞

    req> GET /like-app.asp?softid={softid}

    res> number

#### 新闻列表，新闻的标题和图片等

    req> GET /api/mobile/index.php

    res> application/json

### 主要功能

* 软件列表和搜索

![MacxApps-Search](/images/MacxApps-Search.png)

* 软件分类查看

![MacxApps-Categories](/images/MacxApps-Categories.png)

* 新闻列表和搜索

![MacxApps-News](/images/MacxApps-News.png)

* 软件管理和更新
* 软件下载和安装

### 联系我

* GitHub: [@pingjiang](https://github.com/pingjiang)
