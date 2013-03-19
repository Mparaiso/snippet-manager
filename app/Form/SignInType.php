<?php
namespace Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\FormBuilder;

class SignInType extends AbstractType{

    /**
     * @param \Symfony\Component\Form\FormBuilderInterface $builder
     * @param array $options
     */
    function buildForm(FormBuilderInterface $builder,array $options){
        $builder
            #@note @silex mapper une propriété d'une entité à un champ de formulaire
                ->add("email","text",array("property_path"=>"username"))
                ->add("password","password",array("property_path"=>"password"));
    }
    /**
     * Returns the name of this type.
     *
     * @return string The name of this type
     */
    public function getName()
    {
        return "signin";
    }
}