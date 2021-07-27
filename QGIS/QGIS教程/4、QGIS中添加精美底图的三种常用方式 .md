我之前曾在知乎上回答过一个问题，将**漂亮的地图拆分为2部分，背景底图和专题信息**。

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbQZP8WB3DiaHpIxtzOK2QxemKfTCNd5nB4da0Rt7Bfgjfq0AfOXDbAlw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



好看的地图，需要一个好看的底图来搭配。

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp6jRcgVmnABSGY2ulcM4M7cs2XMN6fJBscbudWgOfMNQjOkrSSdfsz7leicyIkDWIdiayXWkfn3QuIA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

那么如何在QGIS中添加这种精美的底图呢？

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbD4SCgYN3YX3GRXicib4UT4kkV7GsjkMdyO3ZkJxNTBESQDM6xVkIg56w/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp6jRcgVmnABSGY2ulcM4M7cPkqSZ54fTicA5lVlLZJG7mXQXUudKbcAxh3WbRGvIeBJZUwiaUUGQXPg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

两种方法各有优缺点。

![图片](data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==)



首先来看看如何手动添加底图服务？

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp6jRcgVmnABSGY2ulcM4M7c5OnPsc8Id0c924W9ibOtEVd8sOJlAdCtXA39Iopx7K8QyaDQFOGO10A/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



先看几张效果。

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbkI9XbCkapJibPBnRJWeNblhqxHVytRJ5ShjQSZPQJK6cqmric8q5JQzg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbroZA059foMovV4ZZzFbxxya2Cv8bVPLHVibRXH4m6VhyVY0HAKOPTlw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbxDFVTDODAum8M3NXCIW3hH11jp5v0FG0mFkAQM4Wt6hXCDoQHWIkNQ/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



那么这些底图如何添加的呢？其实很简单，在浏览面板中的【Tile Server XYZ】中创建一个新的链接即可。

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbQm2zc44NjABNdqbOCT93AGjjViaXyibdZ1E4A95Grh9sVTuALibQTDAYg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



![图片](data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp6jRcgVmnABSGY2ulcM4M7cib84sYU46GEGDkKIkiaPibLwWia8ognZQ2ZiaGLOBal4ebEDD4f1GClofDg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbuQegtEx9pRuk8YTiaYjmLkr2oz2ERWmlNmTqtNVjiacTnze0PibibqsfSA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp6jRcgVmnABSGY2ulcM4M7cFia6Z0FDPmNaMqapibRmDMHH5VSmxf7JlRA36mpN71F9V59CFyGDv5kw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbwChmicbekicmphqSqeWz6KtTFxMIzgnOE5J3LiaPVicA7hIubNUhSDwuNg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbMkpDFHlqiaRwG0fuZbKDTyfr1M7039oEndbJiayPET3fcVjyQBMc0ibXA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtb2QYaNDa3vbIbXa5tZKqT8Nfibh1icvlIuia7HvWNK3xiagrDhQVHwKVuyA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

接下来再看看如何通过插件的形式来批量地添加多种底图服务。

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp6jRcgVmnABSGY2ulcM4M7cZib9u1JL4VVZESS4F2RM6ibJoAFYIhwAxXRNWfXsm7kjEKJBiacJVQh4A/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbkMMAGsroosBp17GZxTliaWf5hl1rv1vVepVAeXWdqg2GrS3FboecGibQ/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbnTFZRdcBHWJlyovqpia7PKTOBItBUmCic1jwVZ74QEIias2g9RmdsjkQw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbibFfj5giaWSZj3kG5DI0no88lTCBMUzRfmjmzIE7YOSNBL4jibUB0o4Gw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp6jRcgVmnABSGY2ulcM4M7ca1J5ibhiaytvjFSUDNfj73CqdiaAJax3R8kfcckm3nXdUuNf68zy1Jbhg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtbxr40fMNichftr5tk8NXYMJ8bHxcOb6PDtWo8icwfVzNN7Oo0qVCFxJLw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/spZMU6icdHp47mcE9qgwZZyFvA7iaVyKtb21nXWOFgaE4WXUXJ7PoZrmxkTZh1rAUiau0CvSU6fV0CDjJJucJvicwg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)