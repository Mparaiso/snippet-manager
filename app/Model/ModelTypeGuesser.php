<?php

namespace Form;

use Symfony\Component\Form\FormTypeGuesserInterface;
use Symfony\Component\Form\Guess;

class ModelTypeGuesser implements FormTypeGuesserInterface
{

    /**
     * Returns a field guess for a property name of a class
     *
     * @param string $class    The fully qualified class name
     * @param string $property The name of the property to guess for
     *
     * @return Guess\TypeGuess A guess for the field's type and options
     */
    public function guessType($class, $property)
    {
        // TODO: Implement guessType() method.
    }

    /**
     * Returns a guess whether a property of a class is required
     *
     * @param string $class    The fully qualified class name
     * @param string $property The name of the property to guess for
     *
     * @return Guess\Guess A guess for the field's required setting
     */
    public function guessRequired($class, $property)
    {
        // TODO: Implement guessRequired() method.
    }

    /**
     * Returns a guess about the field's maximum length
     *
     * @param string $class    The fully qualified class name
     * @param string $property The name of the property to guess for
     *
     * @return Guess\Guess A guess for the field's maximum length
     */
    public function guessMaxLength($class, $property)
    {
        // TODO: Implement guessMaxLength() method.
    }

    /**
     * Returns a guess about the field's pattern
     *
     * - When you have a min value, you guess a min length of this min (LOW_CONFIDENCE) , lines below
     * - If this value is a float type, this is wrong so you guess null with MEDIUM_CONFIDENCE to override the previous guess.
     * Example:
     *  You want a float greater than 5, 4.512313 is not valid but length(4.512314) > length(5)
     * @link https://github.com/symfony/symfony/pull/3927
     *
     * @param string $class    The fully qualified class name
     * @param string $property The name of the property to guess for
     *
     * @return Guess\Guess A guess for the field's required pattern
     */
    public function guessPattern($class, $property)
    {
        // TODO: Implement guessPattern() method.
    }
}
