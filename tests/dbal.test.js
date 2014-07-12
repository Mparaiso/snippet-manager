/*jslint vars:true,eqeq:true,node:true,es5:true,white:true,plusplus:true,nomen:true,unparam:true,devel:true,regexp:true */
/*global describe,it,beforeEach,expect*/
/*Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.*/ 
/* tests/dbal.test.js */
var assert = require('assert');
var dbal = require('./../coffee/dbal');
describe('dbal',function(){
    "use strict";
    describe('#QueryBuilder',function  () {
        beforeEach(function  () {
            this.createQueryBuilder=function(){
                return new dbal.QueryBuilder({tableName:'foo',idColumnName:'id'});
            };
        });
        it('SELECT should render '+JSON.stringify(['SELECT * FROM ??',['foo']]),function  () {
            var actual= this.createQueryBuilder().select()
            .from('foo')
            .build();
            var expected = ['SELECT * FROM ??',['foo']];
            assert.deepEqual(expected,actual);
        });
        it('UPDATE should render '+JSON.stringify('UPDATE ?? SET (?) WHERE  (?? <=> ? AND ?? NOT IT (?))'),function(){
            var expected;
            var actual=this.createQueryBuilder().update()
            .from('foo')
            .where({bar:"foo",biz:{$nin:[1,2,3,4]}})
            .build({bar:"baz"});
            expected='UPDATE ?? SET (?) WHERE  (?? <=> ? AND ?? NOT IN (?))';
            assert.deepEqual(actual[0],expected);
        });
    });
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
                var eb = new dbal.ExpressionBuilder(fixture.expression);
                assert.deepEqual(eb.build(),[fixture.string,fixture.params]);
            });
        });

    });
});
