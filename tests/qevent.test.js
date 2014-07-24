/*jslint node:true*/
/*global spyOn,expect,it,describe,beforeEach,jasmine*/
describe('qevent', function () {
    "use strict";
    beforeEach(function () {
        this.container = require('./../server.js');
        this.qevent = this.container.qevent;
        this.spy = jasmine.createSpy('spy');
        this.event = "EVENT";
    });
    describe('#has', function () {
        it('qevent has listener', function () {
            this.qevent.on(this.event, this.spy);
            expect(this.qevent.has(this.event, this.spy)).toBe(true);
        });
    });
    describe('#emit', function () {
        it('emit', function (done) {
            this.qevent.on(this.event, this.spy);
            this.qevent.emit(this.event)
                .then(function () {
                    expect(this.spy).toHaveBeenCalled();
                }.bind(this))
                .then(done);
        });
    });
    describe('#on', function () {
        it('should mutate obj', function (done) {
            var callbacks = {
                cb1: function (obj) {
                    obj.foo = "foo";
                    throw 'foo';
                },
                cb2: function (obj) {
                    obj.bar = "bar";
                }
            };

            spyOn(callbacks,'cb1').and.callThrough();
            spyOn(callbacks,'cb2').and.callThrough();
            var baz = new Object();
            this.qevent.on(this.event, callbacks.cb1);
            this.qevent.on(this.event, callbacks.cb2);
            this.qevent.emit(this.event, baz)
                .then(function () {
                    expect(callbacks.cb1).toHaveBeenCalledWith(baz,undefined);
                    expect(callbacks.cb2).toHaveBeenCalledWith(baz,undefined);
                    expect(baz.foo).toEqual('foo');
                    expect(baz.bar).toEqual('bar');
                }.bind(this))
                .then(done);
        });
    });
});