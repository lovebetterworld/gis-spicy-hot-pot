- [maptalks 开发GIS地图（30）maptalks.three.23- custom-electricShield](https://www.cnblogs.com/googlegis/p/14735545.html)

1. 电子罩栏，这个效果很不错了。可是用在什么地方比较合适呢？

2. 定义扩展对象类

```js
class ElectricShield extends maptalks.BaseObject {
            constructor(coordinate, options, material, layer) {
                options = maptalks.Util.extend({}, OPTIONS, options, { layer, coordinate });
                super();
                //Initialize internal configuration
                // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L135
                this._initOptions(options);
                const { altitude, radius } = options;
                //generate geometry
                const r = layer.distanceToVector3(radius, radius).x;
                const geometry = new THREE.SphereBufferGeometry(r, 50, 50, 0, Math.PI * 2);

                //Initialize internal object3d
                // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L140
                // this._createMesh(geometry, material);
                this._createGroup();
                const mesh = new THREE.Mesh(geometry, material);
                this.getObject3d().add(mesh);
                //set object3d position
                const z = layer.distanceToVector3(altitude, altitude).x;
                const position = layer.coordinateToVector3(coordinate, z);
                this.getObject3d().position.copy(position);
                this.getObject3d().rotation.x = Math.PI / 2;
            }

            _animation() {
                const ball = this.getObject3d().children[0];
                const speed = this.getOptions().speed;
                ball.material.uniforms.time.value += speed;
            }
        }
```

3. 电子罩栏的材质，其中使用了 ShaderMaterial

```js
function getMaterial() {
            var ElectricShield = {
                uniforms: {
                time: {
                    type: "f",
                    value: 0
                },
                color: {
                    type: "c",
                    value: new THREE.Color("#9999FF")
                },
                opacity: {
                    type: "f",
                    value: 1
                }
                },
                vertexShaderSource: "\n  precision lowp float;\n  precision lowp int;\n  "
                .concat(
                    THREE.ShaderChunk.fog_pars_vertex,
                    "\n  varying vec2 vUv;\n  void main() {\n    vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );\n    vUv = uv;\n    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);\n    "
                )
                .concat(THREE.ShaderChunk.fog_vertex, "\n  }\n"),
                fragmentShaderSource: `
                #if __VERSION__ == 100
                 #extension GL_OES_standard_derivatives : enable
                #endif
                uniform vec3 color;
                uniform float opacity;
                uniform float time;
                varying vec2 vUv;
                #define pi 3.1415926535
                #define PI2RAD 0.01745329252
                #define TWO_PI (2. * PI)
                float rands(float p){
                    return fract(sin(p) * 10000.0);
                }
                float noise(vec2 p){
                    float t = time / 20000.0;
                    if(t > 1.0) t -= floor(t);
                    return rands(p.x * 14. + p.y * sin(t) * 0.5);
                }
                vec2 sw(vec2 p){
                    return vec2(floor(p.x), floor(p.y));
                }
                vec2 se(vec2 p){
                    return vec2(ceil(p.x), floor(p.y));
                }
                vec2 nw(vec2 p){
                    return vec2(floor(p.x), ceil(p.y));
                }
                vec2 ne(vec2 p){
                    return vec2(ceil(p.x), ceil(p.y));
                }
                float smoothNoise(vec2 p){
                    vec2 inter = smoothstep(0.0, 1.0, fract(p));
                    float s = mix(noise(sw(p)), noise(se(p)), inter.x);
                    float n = mix(noise(nw(p)), noise(ne(p)), inter.x);
                    return mix(s, n, inter.y);
                }
                float fbm(vec2 p){
                    float z = 2.0;
                    float rz = 0.0;
                    vec2 bp = p;
                    for(float i = 1.0; i < 6.0; i++){
                    rz += abs((smoothNoise(p) - 0.5)* 2.0) / z;
                    z *= 2.0;
                    p *= 2.0;
                    }
                    return rz;
                }
                void main() {
                    vec2 uv = vUv;
                    vec2 uv2 = vUv;
                    if (uv.y < 0.5) {
                    discard;
                    }
                    uv *= 4.;
                    float rz = fbm(uv);
                    uv /= exp(mod(time * 2.0, pi));
                    rz *= pow(15., 0.9);
                    gl_FragColor = mix(vec4(color, opacity) / rz, vec4(color, 0.1), 0.2);
                    if (uv2.x < 0.05) {
                    gl_FragColor = mix(vec4(color, 0.1), gl_FragColor, uv2.x / 0.05);
                    }
                    if (uv2.x > 0.95){
                    gl_FragColor = mix(gl_FragColor, vec4(color, 0.1), (uv2.x - 0.95) / 0.05);
                    }
                }`
            };
            let material = new THREE.ShaderMaterial({
                uniforms: ElectricShield.uniforms,
                defaultAttributeValues: {},
                vertexShader: ElectricShield.vertexShaderSource,
                fragmentShader: ElectricShield.fragmentShaderSource,
                blending: THREE.AdditiveBlending,
                depthWrite: !1,
                depthTest: !0,
                side: THREE.DoubleSide,
                transparent: !0
            });
            return material;
        }
```

4. 添加电子罩栏

```js
var ballElectric, material;
function addElectricShield() {
    material = getMaterial();
    ballElectric = new ElectricShield(map.getCenter(), { radius: 500 }, material, threeLayer)
    threeLayer.addMesh(ballElectric);
    initGui();
    animation();
}
```

5. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506155521727-712260832.gif)