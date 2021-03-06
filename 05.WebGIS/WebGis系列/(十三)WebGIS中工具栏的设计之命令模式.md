- [(十三)WebGIS中工具栏的设计之命令模式](https://www.cnblogs.com/naaoveGIS/p/4066959.html)

## 1.背景

从这一章节开始我们将正式进入WebGIS的工具栏中相关功能的设计和实现。我们以ArcMap中的工具栏中的基本工具为模板，将其中的放大、缩小、平移、全图、清除、定位、I查询、距离量测、面积量测在WebGIS中进行实现。

![img](https://images0.cnblogs.com/blog/656746/201411/011200360651625.png)

这里，我先跟大家说一个基本的概念。我们一般将工具分为Command和Tool。所谓command是指该工具被调用后，生效一次即终止。而Tool则是当被调用后，持续有效，直至终止该工具或者切换工具。

按照这个理论，我们可以将工具栏中的基本工具分一下类：

Command：全图、清除、定位。

Tool：放大、缩小、平移、I查询、距离量测、面积量测。

## 2.初步探究

对工具栏中的内部控制哪一个工具该实例化以及生效，可以通过策略模式+工厂模式。但是为了简单，策略模式就足以了。

但是，因为工具栏中有诸多Tool型的工具，简单的策略模式是无法满足Tool终止和切换的需求的。这里我们将用到23种设计模式中的一种：命令模式。

## 3.命令模式简介

### 3.1 使用场景

GOF中给出了命令模式的使用场景：

A、当一个应用程序调用者与多个目标对象之间存在调用关系时，并且目标对象之间的操作很类似的时候。

 B、当一个目标对象内部的方法调用太复杂，或者内部的方法需要协作才能完成对象的某个特点操作时（作者注：比如要对行为进行“记录、撤销/重做、事务”等处理）。

C、调用者调用目标对象后，需要回调一些方法。

分析我们Tool的使用，均是与鼠标事件有关，比如：mouseDown、mouseUp、mouseMove、mouseOut、mouseClick、mouseWheel等。是满足命令模式使用的场景A的，而场景B和C也是很有可能会在我们使用中触发的。

综上分析，进一步证明我们这里选着使用命令模式是正确的。

### 3.2命令模式讲解

这里我先给出命令模式的UML图：

​      ![img](https://images0.cnblogs.com/blog/656746/201411/011200469405002.png)      
以上UML图中涉及到五个角色，它们分别是： 

客户端(Client)角色：创建一个具体命令(ConcreteCommand)对象并确定其接收者。

命令(Command)角色：声明了一个给所有具体命令类的抽象接口。

具体命令(ConcreteCommand)角色：定义一个接收者和行为之间的弱耦合；实现execute()方法，负责调用接收者的相应操作。execute()方法通常叫做执行方法。

请求者(Invoker)角色：负责调用命令对象执行请求，相关的方法叫做行动方法。

接收者(Receiver)角色：负责具体实施和执行一个请求。任何一个类都可以成为接收者，实施和执行请求的方法叫做行动方法。

## 4.系统中命令模式的具体实现

在实际运用中 ，我们经常会对GOF给出的设计模式中的UML稍作变通，以便简化开发或者便于开发。这里，我们也对以上的UML做了些许变化。

我这里先给出变化后的UML图。

![img](https://images0.cnblogs.com/blog/656746/201411/011201217066047.png)

 因为所有的命令都是针对于Map的，所以没有将Command设计成接口，而是让他变成一个抽象类，这样有两个好处：

A.使Map变为属性，直接让Command关联上Map。

B.可以在类中完成部分公用代码，比如mouseWheel()方法所涉及的功能是所有的命令类公用的。

并且舍弃了Receiver这样的接受者的编写，而是直接将Receiver中所涉及到的方法编写移到每一个ConcreteCommand中了。这样可以减少类的个数。

命令的切换由类似于Invoke类的MapNavigation类中的setMapCommand来控制。

## 5.使用命令模式的优点

A.更松散的耦合:

命令模式使得发起命令的对象——客户端，和具体实现命令的对象——接收者对象完全解耦，也就是说发起命令的对象完全不知道具体实现对象是谁，也不知道如何实现。

B.更动态的控制:

命令模式把请求封装起来，可以动态地对它进行参数化、队列化和日志化等操作，从而使得系统更灵活。

C.很自然的复合命令:

命令模式中的命令对象能够很容易地组合成复合命令，也就是宏命令，从而使系统操作更简单，功能更强大。

D.更好的扩展性:

由于发起命令的对象和具体的实现完全解耦，因此扩展新的命令就很容易，只需要实现新的命令对象，然后在装配的时候，把具体的实现对象设置到命令对象中，然后就可以使用这个命令对象，已有的实现完全不用变化。

## 6.总结

在这一章里，我们介绍了命令模式的设计和实现思路。在接下来的章节里，我们将针对我提到的工具栏中的基本工具：放大、缩小、平移、全图、清除、定位、I查询、距离量测、面积量测，的设计和实现进行逐个讲解。