<?php

namespace Form;

use Symfony\Component\OptionsResolver\OptionsResolverInterface;

use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\AbstractType;

class SnippetType extends AbstractType{
	 function buildForm(FormBuilderInterface $builder, array $options){
		$builder->add("title")
			->add("description")
			->add("content","textarea")
			->add("private","checkbox",array("required"=>false))
			->add("tags","text",array("required"=>false))
			->add("category",null,array("property"=>"title"));
	}

	function getName(){
		return "snippet";
	}

	function setDefaultOptions( OptionsResolverInterface $resolver){
		$resolver->setDefaults(array());
	}

}
