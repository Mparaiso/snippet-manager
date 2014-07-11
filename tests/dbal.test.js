/*jslint eqeq:true,node:true,es5:true,white:true,plusplus:true,nomen:true,unparam:true,devel:true,regexp:true */
/*global describe,it,beforeEach,expect*/
var assert = require('assert');
var dbal = require('./../coffee/dbal');
describe('dbal',function(){
    "use strict";
    describe('#QueryBuilder',function  () {
        beforeEach(function  () {
            this.qb = new dbal.QueryBuilder({tableName:'foo',idColumnName:'id'})
        })
        it('should render correctly',function  () {
            var q= this.qb.select()
            .from('foo')
            .build();
            assert.deepEqual(q,['SELECT * FROM foo',[]])
        })
    })
    describe('#ExpressionBuilder',function(){
        [
            {expression:{a:1,b:2},string:" (?? <=> ? AND ?? <=> ?) ",params:['a',1,'b',2]},
            {expression:{$or:{a:1,b:2}},string:" ( (?? <=> ? OR ?? <=> ?) ) ",params:['a',1,'b',2]},
            {expression:{a:{$in:[1,2,3]}},string:" (?? IN (?)) ",params:['a',[1,2,3]]},
            {expression:{a:{$nin:[1,2,3]}},string:" (?? NOT IN (?)) ",params:['a',[1,2,3]]},
            {expression:{a:{$gte:2}},string:" (?? >= ?) ",params:['a',2]},
            {expression:{$not:{a:2,b:4}},string:" ( NOT (?? <=> ? AND ?? <=> ?) ) ",params:["a",2,"b",4]},
            {expression:{a:{$neq:1}},string:" (?? != ?) ",params:['a',1]},
            {expression:{a:{$gt:0,$lt:10,$neq:5},b:{$in:[1,2]}},string:" ( ( ?? > ? AND ?? < ? AND ?? != ? )  AND ?? IN (?)) ",params:['a',0,'a',10,'a',5,'b',[1,2]]}
        ].forEach(function(fixture){
            it(JSON.stringify(fixture.expression)+' should render '+fixture.string,function(){
                var eb = new dbal.ExpressionBuilder(fixture.expression)
                assert.deepEqual(eb.build(),[fixture.string,fixture.params]);
            })
        })

    })
})
