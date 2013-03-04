<?php
namespace  Form;

use Symfony\Component\Form\AbstractType   ;
use Symfony\Component\Form\FormBuilderInterface;
class CategoryType   extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options){
        $builder->add("title")
            ->add("description");

    }
    public function getName()
    {
        return "category";
    }
}
