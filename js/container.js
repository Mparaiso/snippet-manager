// Generated by CoffeeScript 1.7.1

/**
 * Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.
 * Snipped , manage your snippets online
 */


/* IoC container */

(function() {
  var Pimple, RedisStore, container, express, flash, mysql, path, q, redis, slug, swig, util, _,
    __slice = [].slice;

  Pimple = require("pimple");

  express = require("express");

  mysql = require("mysql");

  q = require("q");

  path = require("path");

  swig = require("swig");

  slug = require("slug");

  _ = require("lodash");

  util = require("util");

  flash = require("connect-flash");

  redis = require('redis');

  RedisStore = require('connect-redis')(express);

  container = new Pimple({
    debug: process.env.NODE_ENV === "production" ? false : true,
    secret: "Secret sentence",
    isHeroku: process.env.IS_HEROKU,
    ip: process.env.OPENSHIFT_NODEJS_IP || "127.0.0.1",
    port: process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000,
    google_analytics_id: "",
    db: {
      host: process.env.SNIPPED_DBHOST,
      user: process.env.SNIPPED_DBUSER,
      password: process.env.SNIPPED_DBPASSWORD,
      database: process.env.SNIPPED_DBNAME
    },
    redis: {
      port: process.env.SNIPPED_REDIS_PORT,
      host: process.env.SNIPPED_REDIS_HOST,
      debug_mode: false,
      password: process.env.SNIPPED_REDIS_PASSWORD
    },
    session: {
      ttl: 1000 * 60 * 60 * 24,
      name: "snipped",
      secret: "my secret session sentence"
    },
    elasticSearch: {
      url: process.env.SNIPPED_ELASTIC_SEARCH_URL
    },
    name: "snipped",
    snippet_per_page: 20,
    category_per_page: 10
  });

  container.set('_', function() {
    return _;
  });

  container.set('q', function() {
    return q;
  });

  container.set('redisClient', container.share(function(c) {
    return redis.createClient(c.redis.port, c.redis.host, {
      auth_pass: c.redis.password
    });
  }));

  container.set('locals', {
    title: "Snipped",
    subtitle: "manage your snippets online",
    slogan: "manage your snippets online"
  });

  container.set('form', container.share(function(c) {
    return require('mpm.form');
  }));

  container.set('sessionMiddleware', container.share(function(c) {
    if (!c.debug) {
      return c.middlewares.redisSession();
    } else {
      return c.middlewares.inMemorySession();
    }
  }));

  container.set('acl', container.share(function(c) {
    var Acl, acl;
    Acl = require('virgen-acl').Acl;
    acl = new Acl;

    /* set up roles */
    acl.addRole("member");
    acl.addRole('administrator', 'member');
    acl.addResource('snippet');
    acl.addResource('route');
    acl.deny();
    acl.allow('administrator');
    acl.allow('member', 'snippet', ['create', 'update', 'delete']);
    acl.allow(null, 'snippet', ['list', 'read']);
    acl.allow('member', 'route', ['/profile', '/profile/snippet', '/profile/signout', '/profile/favorite', '/profile/snippet/create', '/profile/snippet/:snippetId/update', '/profile/snippet/:snippetId/delete', '/profile/snippet/:snippetId/favorite']);
    acl.allow(null, 'route', ['/', '/*', '/snippet', '/snippet/:snippetId/:snippetTitle?', '/category/:categoryId/:categoryTitle?', '/join', '/signin']);
    acl.deny('member', 'route', ['/signin', '/join']);
    acl.pquery = function() {
      return q.ninvoke.apply(q, [acl, 'query'].concat(__slice.call(arguments)));
    };
    return acl;
  }));

  container.set('swig', container.share(function() {
    swig.setDefaults({
      cache: container.debug ? false : "memory"
    });
    swig.setFilter('slug', slug);
    return swig;
  }));


  /*
      middlewares
   */

  container.set('middlewares', container.share(function(c) {
    var aclQueryCallbackForMiddlewares;
    aclQueryCallbackForMiddlewares = function(req, res, next) {
      return function(err, isAllowed) {
        if (isAllowed === true) {
          return next();
        } else if (err) {
          return next(err);
        } else {
          return res.send(401);
        }
      };
    };
    return {

      /*
          session stored in memory
       */
      inMemorySession: function() {
        return express.session({
          secret: c.secret,
          name: c.name,
          httpOnly: true,
          maxAge: 60 * 60 * 1000
        });
      },

      /*
          session stored in redis
       */
      redisSession: function() {
        return express.session({
          ttl: c.session.ttl,
          name: c.session.name,
          secret: c.session.secret,
          store: new RedisStore({
            client: c.redisClient
          })
        });
      },

      /*
          query acl for authorization
       */
      queryAcl: function(resource, action) {
        return function(req, res, next) {
          return c.acl.query(req.isAuthenticated() && req.user, resource, action, aclQueryCallbackForMiddleWares(req, res, next));
        };
      },

      /*
          signin user with passport
       */
      signIn: function(successRedirect, failureRedirect, failureFlash) {
        if (successRedirect == null) {
          successRedirect = '/profile';
        }
        if (failureRedirect == null) {
          failureRedirect = '/signin';
        }
        if (failureFlash == null) {
          failureFlash = true;
        }
        return c.passport.authenticate('local-login', {
          successRedirect: successRedirect,
          failureRedirect: failureRedirect,
          failureFlash: failureFlash
        });
      },

      /*
          creates a middleware that uses virgen-acl , passport, and route resource to decide url access control
       */
      firewall: function(acl, strict) {
        var findRoute, routes;
        if (strict == null) {
          strict = true;
        }
        routes = void 0;
        findRoute = _.memoize(function(url) {
          return _(routes).find(function(route) {
            return route.regexp.test(url);
          });
        });
        return function(req, res, next) {
          var route, _ref;
          if (routes == null) {
            routes = _(req.app.routes).values().flatten(true).value();
          }
          route = findRoute(req.url);
          if (route) {
            return acl.query(req.isAuthenticated() && ((_ref = req.user) != null ? _ref.getRoleId() : void 0), 'route', route.path, function(err, isAllowed) {
              var _ref1;
              if (err) {
                return next(err);
              } else if (!isAllowed) {
                return res.send(401, "user " + req.user + " with role " + ((_ref1 = req.user) != null ? _ref1.getRoleId() : void 0) + " is not allowed on route " + route.path);
              } else {
                return next();
              }
            });
          } else if (strict) {
            return res.send(404, 'route not found with strict firewall');
          } else {
            return next();
          }
        };
      }
    };
  }));

  container.set('params', container.share(function(c) {
    return {
      snippetId: function(req, res, next, id) {
        return c.Snippet.findById(id).then(function(snippet) {
          if (snippet) {
            res.locals.snippet = snippet;
            return next();
          } else {
            throw "snippet with id " + id + " not found";
          }
        })["catch"](function(err) {
          return next(err);
        });
      },
      categoryId: function(req, res, next, id) {
        return c.Category.findById(req.params.categoryId).then(function(category) {
          if (category) {
            res.locals.category = category;
            return next();
          } else {
            throw "category with id " + id + " not found";
          }
        })["catch"](function(err) {
          return next(err);
        });
      }
    };
  }));

  container.set("passport", container.share(function(container) {
    var LocalStrategy, passport;
    passport = require("passport");
    LocalStrategy = require("passport-local").Strategy;
    passport.serializeUser(function(user, done) {
      return done(null, user.id);
    });
    passport.deserializeUser(function(id, done) {
      return container.User.findById(id).done(done);
    });
    passport.use('local-login', new LocalStrategy({
      usernameField: 'email',
      passwordField: 'password',
      passReqToCallback: true
    }, function(req, email, password, done) {
      return container.User.findByEmail(email).then(function(user) {
        switch (false) {
          case !(user && container.User.validPassword(user.password, password)):

            /* register user in acl */
            return user;
          default:
            req.flash('danger', "Invalid credentials");
            return false;
        }
      })["catch"](function(err) {
        return done(err);
      }).then(function(user) {
        return done(null, user);
      });
    }));
    return passport;
  }));

  container.set("events", container.share(function(container) {
    return {

      /* Promise<snippet> , container , req , res, next */
      'SNIPPET_AFTER_CREATE': 'SNIPPET_AFTER_CREATE'
    };
  }));


  /*
      Express app configuration
   */

  container.set('app', container.share(function(c) {
    var app;
    app = express();

    /* static assets */
    app.disable('x-powered-by');
    app.use('/css', require('less-middleware')(path.join(__dirname, '..', 'public', 'css'), {
      once: c.debug ? true : false
    }));
    app.use(express["static"](path.join(__dirname, "..", "public"), {
      maxAge: 100000
    }));

    /* logging */

    /* passport user management */
    app.use(express.cookieParser(c.secret));

    /* session middleware */
    app.use(c.sessionMiddleware);
    app.use(flash());
    app.use(c.passport.initialize());
    app.use(c.passport.session());
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.engine('twig', c.swig.renderFile);
    app.set('view engine', 'twig');
    app.use(function(req, res, next) {
      _.defaults(res.locals, c.locals);
      res.locals.flash = req.flash();
      return next();
    });

    /* errors */
    if (c.debug) {
      app.enable('verbose errors');
      app.use(express.errorHandler());
      app.use(express.logger('dev'));
    } else {
      app.disable('verbose errors');
      app.disable('view cache');
    }
    app.use(function(req, res, next) {
      if (req.isAuthenticated()) {
        res.locals.user = req.user;
        res.locals.isAuthenticated = true;
      } else {
        res.locals.user = void 0;
        res.locals.isAuthenticated = false;
      }
      return next();
    });

    /* firewall */
    app.use(c.middlewares.firewall(c.acl));

    /* subroute for profile */
    app.use('/profile', (function(r, res, next) {
      res.locals.route = "profile";
      return next();
    }));
    app.get('/profile', c.UserController.profileIndex);
    app.all('/profile/snippet/create', c.UserController.profileSnippetCreate);
    app.all('/profile/snippet/:snippetId/update', c.UserController.profileSnippetUpdate);
    app.post('/profile/snippet/:snippetId/delete', c.UserController.profileSnippetDelete);
    app.post('/profile/snippet/:snippetId/favorite', c.UserController.profileSnippetFavoriteToggle);
    app.get('/profile/snippet', c.UserController.profileSnippet);
    app.get('/profile/favorite', c.UserController.profileFavorite);
    app.get('/profile/signout', c.UserController.signOut);

    /* public routes */
    app.get('/*', function(req, res, next) {
      return c.CategoryWithSnippetCount.findAll({
        limit: 10
      }).then(function(categories) {
        res.locals.categoriesWithSnippetCount = categories;
        return next('route');
      })["catch"](next);
    });
    app.get('/snippet/:snippetId/:snippetTitle?', c.IndexController.readSnippet);
    app.get('/category/:categoryId/:categoryTitle?', c.IndexController.readCategory);
    app.all('/join', c.UserController.register);
    app.get('/signin', c.UserController.signIn);
    app.post('/signin', c.middlewares.signIn());
    app.get('/', c.IndexController.index);
    app.all('/*', function(req, res, next) {
      var err;
      err = new Error('not found');
      err.status = 404;
      return next(err);
    });
    if (!c.debug) {
      app.use(c.ErrorController['500']);
    }
    return app;
  }));

  container.set('qevent', container.share(function(c) {
    var qevent;
    qevent = new c.EventEmitter(c.q);
    return qevent;
  }));

  container.set('EventEmitter', container.share(function(c) {
    var EventEmitter;
    return EventEmitter = (function() {
      function EventEmitter(_Q, _eventList) {
        this._Q = _Q;
        this._eventList = _eventList != null ? _eventList : [];
      }

      EventEmitter.prototype.on = function(event, listener) {
        if (typeof event === "string") {
          event = {
            name: event,
            listener: listener,
            priority: 0
          };
        }
        return this._eventList.push(event);
      };

      EventEmitter.prototype.off = function(eventName, listener) {
        this._eventList.filter(function(el) {
          if (el.name === eventName && listener) {
            return el.listener === listener;
          } else {
            return true;
          }
        }).forEach((function(_this) {
          return function(el) {
            return _this._eventList.splice(_this._eventList.indexOf(el), 1);
          };
        })(this));
        return this;
      };

      EventEmitter.prototype.emit = function() {
        var args, eventName;
        eventName = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        return this._eventList.filter(function(e) {
          return e.name === eventName;
        }).sort(function(a, b) {
          return b.priority - a.priority;
        }).reduce((function(q, next) {
          var _ref;
          return q.then((_ref = next.listener).bind.apply(_ref, [next.listener].concat(__slice.call(args))));
        }), this._Q());
      };

      EventEmitter.prototype.once = function(eventName, listener) {
        var _evName, _listener;
        if (typeof eventName !== "string") {
          _evName = eventName.name;
        } else {
          _evName = eventName;
        }
        _listener = (function(_this) {
          return function() {
            _this.off(eventName, listener);
            return listener.apply(null, arguments);
          };
        })(this);
        return this.on(eventName, _listener);
      };

      EventEmitter.prototype.has = function(eventName, listener) {
        return this._eventList.some(function(event) {
          return event.name === eventName && event.listener === listener;
        });
      };

      return EventEmitter;

    })();
  }));

  container.register(require('./model'));

  container.register(require('./controller'));

  container.register(require('./event'));

  container.register(require('./form'));

  module.exports = container;

}).call(this);
