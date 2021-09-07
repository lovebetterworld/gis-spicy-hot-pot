- [three.js 如何使用webworker](https://blog.csdn.net/qq_39503511/article/details/119979900)

# 概述

主要介绍如何在three.js中使用webworker，主要以两个案例说明，一个使用worker一个不使用worker他们的性能有什么有什么区别，首先我们先创建1000个mesh，然后每隔一秒随机改变mesh的位置。

# 不使用worker

```javascript
	const geometry = new THREE.BoxGeometry( 1, 1, 1 );
    const material = new THREE.MeshBasicMaterial( {color: 0x00ff00} );
    const cube = new THREE.Mesh( geometry, material );
    const group = new THREE.Group();
    scene.add(group);

    const num = 1000;
    const min = -60;
    const max = 60;

    function RandomNum(Min, Max) {
      const Range = Max - Min;
      const Rand = Math.random();
      const num = Min + Math.floor(Rand * Range);  //舍去
      return num;
    }

    for (let i = 0; i < num; i++) {
      const cube_clone = cube.clone();
      const material = cube.material.clone();
      material.color = new THREE.Color(`rgb(${RandomNum(0, 255)}, ${RandomNum(0, 255)}, ${RandomNum(0, 255)})`);
      const position = [RandomNum(min, max), RandomNum(min, max), RandomNum(min, max)];
      cube_clone.material = material;
      cube_clone.position.set(...position);
      group.add(cube_clone);
    }

    function move() {
      for (let i = 0; i < num; i++) {
        let position;
        for (let j = 0; j < 10000; j++) {
          position = [RandomNum(min, max), RandomNum(min, max), RandomNum(min, max)];
        }
        group.children[i].position.set(...position);
      }
    }
    
    setInterval(() => {
      move();
    }, 1000)
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/fbdda8ca2b5a42b687f2e9b2b134b43e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oiR5oOz5b2T5Zad5rC05Lq6,size_20,color_FFFFFF,t_70,g_se,x_16)
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/50d2215c4d25429b82b7e749c0f7c6f8.png)

从效果中我们可以看到做左上角的fps值显示只有5左右，界面会变得非常卡顿。

# 使用worker

```javascript
const num = 1000;
    const min = -60;
    const max = 60;

    function RandomNum(Min, Max) {
      const Range = Max - Min;
      const Rand = Math.random();
      const num = Min + Math.floor(Rand * Range);  //舍去
      return num;
    }

    for (let i = 0; i < num; i++) {
      const cube_clone = cube.clone();
      const material = cube.material.clone();
      material.color = new THREE.Color(`rgb(${RandomNum(0, 255)}, ${RandomNum(0, 255)}, ${RandomNum(0, 255)})`);
      const position = [RandomNum(min, max), RandomNum(min, max), RandomNum(min, max)];
      cube_clone.material = material;
      cube_clone.position.set(...position);
      group.add(cube_clone);
    }

    const w = new Worker('./move.js')
    w.postMessage({num, min,max});
    w.onmessage = function (event) {
      for (let i = 0; i < num; i++) {
        let position = event.data[i];
        group.children[i].position.set(...position);
      }
    }
```

move.js代码

```javascript
function RandomNum(Min, Max) {
  var Range = Max - Min;
  var Rand = Math.random();
  var num = Min + Math.floor(Rand * Range); //舍去
  return num;
}

let num;
let min;
let max;

let positions = [];

function move() {
  positions = [];
  for (var i = 0; i < num; i++) {
    let position;
    for (let j = 0; j < 10000; j++) {
      position = [RandomNum(min, max), RandomNum(min, max), RandomNum(min, max)];
    }
    positions.push(position);
    if (i === num - 1) {
      postMessage(positions)
    }
  }
}

onmessage = function (event) {
  num = event.data.num;
  min = event.data.min;
  max = event.data.max;
  setInterval(() => {
    move();
  }, 1000)
}
```

此时我们再看下效果
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/7f7911c292f44e56a14bb07668ed6070.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oiR5oOz5b2T5Zad5rC05Lq6,size_20,color_FFFFFF,t_70,g_se,x_16)
 我们可以看到界面依旧保持60fps，界面很流畅，每一个mesh也是在随机的更新位置。由此可以得出，在做大量计算的时候可以开启worker。