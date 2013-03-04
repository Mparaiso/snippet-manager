<?php

namespace Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;

class RegistrationType extends AbstractType{

	/**
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->add("username")
			->add("email","email")
			#@note @symfony utiliser un password repeated pour l'enregistrement
			# et la confirmation de mots de passes.
			->add("password","repeated",array(
				"type"=>"password",
				"first_options"=>array(
					"label"=>"password"),
				"second_options"=>array(
					"label"=>"confirm password"
					),"property_path"=>"passwordHash"
				))
			->add("terms_of_service","checkbox",array("mapped"=>false));
	}


	/**
	 *
	 */
	public function getName() {
		return "user";

	}


}