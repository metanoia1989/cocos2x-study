//########################################################
// js prototype 原型链机制理解 
//########################################################

// Unlike most other popular object-oriented languages, JavaScript has no
// concept of 'instances' created from 'class' blueprints; instead, JavaScript
// combines instantiation and inheritance into a single concept: a 'prototype'.

// Every JavaScript object has a 'prototype'. When you go to access a property
// on an object that doesn't exist on the actual object, the interpreter will
// look at its prototype.
// 当访问一个对象的属性时，如果这个属性不存在于这个对象上，那么解释器会去它的原型上查找。


// Some JS implementations let you access an object's prototype on the magic property `__proto__`.
// While this is useful for explaining prototypes it's not part of the standard;
// 原型不是js标准的一部份，只是一些js的实现让你可以通过 `__proto__` 魔法属性访问一个对象的原型
// 在 JavaScript 的标准中，__proto__ 是一个非标准的属性，尽管它在大多数现代浏览器中得到支持，但并不是 ECMAScript 规范的一部分。
// 在 ECMAScript 2015（ES6）中，引入了 Object.getPrototypeOf() 和 Object.setPrototypeOf() 方法，提供了更标准化的方式来获取和设置对象的原型。

const obj = {
    greet: 'hello world',
}
const prototype = {
    meaningOfLife: 42,
    func: function() {
        return this.greet.toLowerCase()
    }
}

// 两种方式都行，基本上js解释器都会实现 __proto__ 属性
obj.__proto__ = prototype
// Object.setPrototypeOf(obj, prototype)

// obj 本身没有 meaningOfLife, func 方法，但是通过其原型，能够找到 
console.log('obj.meaningOfLife', obj.meaningOfLife)
console.log('obj.func()', obj.func())

// 当然，如果你的属性不在你的原型上，则会搜索原型的原型，依此类推。
// if your property isn't on your prototype, the prototype's prototype is searched, and so on.
// 所以js对对象属性的搜索，会沿着原型链一直向上查找，这点跟lua是不同的  
prototype.__proto__ = {
    boolean: true,
}
console.log('obj.boolean', obj.boolean) // 在obj的原型上是找不到的，但是在整个原型链上是能找到的 


// 这里不存在复制；每个对象都存储对其原型的引用。这意味着我们可以修改原型，并且我们的更改将会在所有地方反映出来。
// There's no copying involved here; each object stores a reference to its prototype. 
// This means we can alter the prototype and our changes will be reflected everywhere.
prototype.meaningOfLife = 43
console.log('obj.meaningOfLife', obj.meaningOfLife) // 43

// 使用 for .. in 遍历对象的所有属性，包括对象自身的属性和原型的属性
// The for/in statement allows iteration over properties of an object,
// walking up the prototype chain until it sees a null prototype.
for (const key in obj) {
    console.log('obj.key', key, '->', obj[key])
}
// 使用 Object.hasOwnProperty 方法来判断属性是否是对象自身的属性
// To only consider properties attached to the object itself and 
// not its prototypes, use the `hasOwnProperty()` check.
for (const key in obj) {
    if (obj.hasOwnProperty(key)) {
        console.log('obj.key by #self', key, '->', obj[key])
    }
}

// 检查基础对象 Object 的原型链
console.log('===========================================')
console.log('Object 自身原型 -> ', Object.__proto__) // {}
console.log('Object 自身原型的原型 -> ', Object.__proto__.__proto__) // [Ojbect: null prototype] {}
console.log('Object 自身原型的原型的原型 -> ', Object.__proto__.__proto__.__proto__) // null
// Object 在 JavaScript 中是一个函数对象。
// 当你访问 Object.__proto__，你实际上是在访问 Object 函数对象的原型，而不是 Object.prototype。
// Object.__proto__ 指向 Function.prototype，因为 Object 是一个函数对象。 
// Object.__proto__.__proto__ 实际上是 Function.prototype.__proto__，它指向 Object.prototype。
// Object.prototype 是原型链的顶端，它的 __proto__ 是 null。

// 验证上面的论述 
console.log('===========================================')
console.log('Object 是函数对象:', typeof Object === 'function')
console.log('Object.__proto__ === Function.prototype:', Object.__proto__ === Function.prototype)
console.log('Object.__proto__.__proto__ === Object.prototype:', Object.__proto__.__proto__ === Object.prototype)
console.log('Object.prototype.__proto__ === null:', Object.prototype.__proto__ === null)

console.log('===========================================')
console.log('Object 自身（作为函数对象）的原型 -> ', Object.__proto__)
console.log('Object.prototype（所有对象的原型） -> ', Object.prototype)
console.log('Object.prototype 的原型 -> ', Object.prototype.__proto__)

// 具体详细的可以看 MDN 文档，这篇文档看完并实践一下，js 的原型链基本就理解了 
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object 

