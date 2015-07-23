<?php
namespace Controller;

use Silex\ControllerProviderInterface;
use Form\SignInType;
use Symfony\Component\HttpFoundation\Session\Session;
use Form\RegistrationType;
use Entity\Account;
use Entity\User;
use Symfony\Component\HttpFoundation\Request;
use Silex\Application;

/**
 * fr : Enregistre , Connecte , Déconnecte un utilisateur.
 * @author M.Paraiso
 */
class AccountController  implements ControllerProviderInterface
{

    function index(Request $request,Application $app){
        /* @var $user \Entity\User */
        $user = $app["security"]->getToken()->getUser();
        $snippets = $app["snippet_service"]->findBy(array("user"=>$user));
        return $app["twig"]->render("account_index.html.twig",array(
            "user"=>$user,"gravatarUrl"=>md5($user->getAccount()->getEmail()),
        ));
    }
    /**
     * FR : Enregistre un nouvel utilisateur
     * EN : register a new user
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @param \Silex\Application $app
     * @return mixed
     */
    function register(Request $request, Application $app)
    {
        $account = new Account();
        /* @var $form \Symfony\Component\Form\Form */
        $form = $app['form.factory']->create(new RegistrationType(), $account);
        if ("POST" === $request->getMethod()) {
            $form->bind($request);
            if ($form->isValid()) {
                $app["account_service"]->register($account);
                /* @var $session \Symfony\Component\HttpFoundation\Session\Session */
                $session = $app["session"];
                $session->getFlashBag()->set("success", "Your account has been created , pleas sign in");
                return $app->redirect("/");
            }
        }

        return $app["twig"]->render("account_register.html.twig", array(
            "form" => $form->createView(),
        ));
    }

    function login(Request $request, Application $app)
    {
        $user = new User;
        $form = $app["form.factory"]->create(new SignInType, $user);
        if ($request->attributes->has($app["security"]::AUTHENTICATION_ERROR)) {
            $error = $request->attributes->get($app["security"]::AUTHENTICATION_ERROR);
        } else {
            $error = $app["session"]->get($app["security"]::AUTHENTICATION_ERROR);

            $app["session"]->remove($app["security"]::AUTHENTICATION_ERROR);
        }
        if($error){
            $app["session"]->getFlashBag()->add("error", $error->getMessage());
        }
        return $app["twig"]->render("account_signin.html.twig",
            array("form" => $form->createView()));
    }

    function loginCheck(Request $request, Application $app){}

    /**
     * Returns routes to connect to the given application.
     *
     * @param Application $app An Application instance
     *
     * @return ControllerCollection A ControllerCollection instance
     */
    public function connect(Application $app)
    {
        /* @var $controllers \Silex\ControllerCollection */
        $controllers = $app["controllers_factory"];
        $controllers->match("/",array($this,"index"))->bind("account_index");
        $controllers->match("/register", array($this, "register"))->bind("account_register");
        $controllers->match("/login", array($this, "login"))->bind("account_login");
        $controllers->post("/login-check", array($this, "loginCheck"))->bind("account_check");
        return $controllers;
    }
}