- [Three.js项目 智慧城市(四)](https://blog.csdn.net/qq_39503511/article/details/112803154)

# 创建文本

想要创建文本，我这边使用得方案是canvas贴图，当然使用css3DRender这些都可以

1. 首先我们先创建html

```javascript
<div class="sprite-canvas">
    <span class="sprite-layer">${name}</span>
</div>

<style lang="less">
.sprite-canvas {
  position: absolute;
  width: 1024px;
  height: 1024px;
  font-size: 128px;
  top: 0;
  box-sizing: border-box;
  background-color: transparent;
  color: #fff;
  text-align: center;
  .sprite-layer {
    margin-top: 60%;
    background-color: blue;
    padding: 1% 2%;
  }
}
</style>
```

1. 使用htmlCanvas来创建成canvas

```javascript
export function createSprite(group, name, position) {
  const html = `
                    <div class="sprite-canvas">
                        <span class="sprite-layer">${name}</span>
                    </div>`;

  document.body.insertAdjacentHTML("beforeend", html);
  const element = document.body.lastChild;
  element.style.zIndex = -1;
  html2canvas(element, {
    backgroundColor: "transparent"
  }).then(canvas => {
    let texture = new THREE.Texture(canvas);
    texture.needsUpdate = true;

    let spriteMaterial = new THREE.SpriteMaterial({
      map: texture
    });
    let sprite = new THREE.Sprite(spriteMaterial);
    sprite.name = name;
    sprite.position.set(...position);
    sprite.scale.set(60, 60, 60);
    group.add(sprite);
    document.body.removeChild(element);
  });
}
```

1. 导入数据创建精灵贴图

```javascript
address.forEach((item) => {
        createSprite(cavasHtmlGroup, item.name, item.position);
      });
```

此时看到得效果是
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210119114152630.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 \4. 最后添加上小精灵飞行调用函数

```javascript
// 点击精灵飞行
      app.initRaycaster((obj) => {
        if (obj.isSprite) {
          address.forEach((item) => {
            if (item.name === obj.name) {
              app.flyTo({
                position: item.cameraPosition,
                duration: 1500,
              });
            }
          });
        }
      });
```

完成最后效果！