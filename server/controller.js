module.exports = {
    register: function (c) {
        c.app.get('/foo', function (req, res) {
            res.send('foo');
        })
    }
};