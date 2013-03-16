<?php
namespace Controller;

use Silex\ControllerProviderInterface;
use Form\RegistrationType;
use Entity\Account;
use Entities\User;
use Symfony\Component\HttpFoundation\Request;
use Silex\Application;

/**
 * fr : Enregistre , Connecte , Déconnecte un utilisateur.
 * @author M.Paraiso
 */
class SecurityController implements  ControllerProviderInterface{

    /**
     * FR : Enregistre un nouvel utilisateur
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @param \Silex\Application $app
     * @return mixed
     */
    function register(Request $request,Application $app){
        $account = new Account();
        /* @var $form \Symfony\Component\Form\Form */
        $form = $app['form.factory']->create(new RegistrationType(),$account);
        if("POST"===$request->getMethod()){
            $form->bind($request);
            if($form->isValid()){
                $app["user_service"]->register($account);
                return $app->redirect("/");
            }
        }
        return $app["twig"]->render("security_register.html.twig",array(
            "form"=>$form->createView(),
        ));
    }
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
        $controllers->match("register",array($this,"register"))->bind("security_register");
        return $controllers;
    }
}