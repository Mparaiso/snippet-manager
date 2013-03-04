INSERT INTO "snippets" VALUES(1,'Javascript Alert','Javascript Alert','<script type=''text/javascript''>
window.alert("blop");
</script>',1334158915,1334158915,2,2,1,0,0,0);
INSERT INTO "snippets" VALUES(2,'SQL DELETE','SQL DELETE','
DELETE FROM "nom de table"
WHERE {condition}

DELETE FROM Store_Information
WHERE store_name = "Los Angeles"

',1334158967,1334158967,6,2,0,0,0,0);
INSERT INTO "snippets" VALUES(3,'Manipulating Configuration Data with Zend_Config','Manipulating Configuration Data with Zend_Config','// XML

<?xml version=''1.0''?>
<config>
  <dialer>
    <number>12345678</number>
    <retries>15</retries>
    <protocol>ppp</protocol>
  </dialer>
</config>

// PHP 

<?php
// include auto-loader class
require_once ''Zend/Loader/Autoloader.php'';

// register auto-loader
$loader = Zend_Loader_Autoloader::getInstance();

// read XML config file
$config = new Zend_Config_Xml(''config.xml'', ''dialer'');

// access individual nodes
printf("Number: %s \r\n", $config->number);
printf("Retries: %s \r\n", $config->retries);
printf("Protocol: %s \r\n", $config->protocol);
?>',1334159127,1334159127,1,2,0,0,0,0);
INSERT INTO "snippets" VALUES(4,'C# convert video using FFMPEG','C# convert video using FFMPEG','// console application
using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
namespace flvToMp4
{
    class Program
    {
        private const string DEFAULT_DIRECTORY = @"C:\Users\mark prades\Videos";
        private string[] INPUT_FILE_FORMATS = { "flv", "avi", "wmv" };
        private string[] OUTPUT_FILE_FORMATS = { "mp4" };
        private DirectoryInfo directoryInfo;
        private FileInfo[] files;
        private string output_file_format;
        public Program()
        {
            Console.WriteLine("Movie converter ( using FFMPEG )");
        }
        static void Main(string[] args)
        {
            //TODO récuperer les paramètres d''application
            //@TODO vérifier si le premier paramètre est un répertoire
            //@TODO vérifier si le second paramètre est un type de fichier si oui
            //@TODO vérifier si le troisième paramètre est un type de fichier
            //@TODO sinon , utiliser les valeurs par défaut
            var program = new Program();
            switch (args.Length)
            {
                case 1:
                    if (Directory.Exists(args[0]))
                    {
                        program.processFiles(args[0]);
                    }
                    break;
                case 2:
                    if (Directory.Exists(args[0]))
                    {
                        program.processFiles(args[0], args[1]);
                    }
                    break;
                default:
                    program.processFiles(DEFAULT_DIRECTORY);
                    break;
            }
        }
        private void processFiles(string directory, string output_file_format = "mp4")
        {
            this.output_file_format = output_file_format;
            // créer un objet pour le répertoire
            directoryInfo = new DirectoryInfo(directory);
            // récupère les fichiers du répertoire
            // en filtrant les fichiers suivant les extensions contenues tableau INPUT_FILE_FORMATS
            // ( on teste chaque extension en elevant le .
            this.files = directoryInfo.GetFiles().Where(
                c => INPUT_FILE_FORMATS.Contains(c.Extension.Remove(0, 1))
                ).ToArray();
            // on traite chaque fichier avec FFMPEG
            // idéallement , on lance FFMEG et on 
            // attend la fin de chaque traitement pour lancer le traitement suivant
            files = files.OrderBy(o=>o.Length).ToArray();
            files.All(c => { Console.WriteLine(c.ToString()); return true; });
            if (files.Length > 0)
            {
                processMovieFile(files.First(), output_file_format);
            }
            Console.ReadLine();
        }
        private void processMovieFile(FileInfo fileInfo,string output_file_format)
        {
            System.Diagnostics.ProcessStartInfo myInfo =
                new System.Diagnostics.ProcessStartInfo();
            myInfo.FileName = "ffmpeg";
            myInfo.Arguments = " -y -i \"" + fileInfo.Name +"\"  \""+
              fileInfo.Name.Remove(fileInfo.Name.LastIndexOf(fileInfo.Extension))+"."+output_file_format+"\" ";
            myInfo.WorkingDirectory = directoryInfo.FullName;
            System.Diagnostics.Process process = new System.Diagnostics.Process();
            process.EnableRaisingEvents = true;
            process.Exited += new EventHandler(process_Exited);
            process.StartInfo = myInfo;
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.UseShellExecute = false;
            process.Start();
        }
        void process_Exited(object sender, EventArgs e)
        {
            //throw new NotImplementedException();
            Console.WriteLine("end of process");
            files = files.Where(c => c != files.First()).ToArray();
            if (files.Length > 0)
            {
                processMovieFile(files.First(), output_file_format);
            }
        }
    }
}
',1334159264,1334159264,12,2,0,0,0,0);
INSERT INTO "snippets" VALUES(5,'SQLite  - How to show the schema for a SQLite database table','description of the snippet','To view the schema for a SQLite database table, just use the SQLite schema dot command, like this:

sqlite> .schema salespeople
(Note that you don''t need to use a semi-colon at the end of that command.)

For my "salespeople" example SQLite table, this SQLite schema command produces the following output:

CREATE TABLE salespeople (
  id INTEGER PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  commission_rate REAL NOT NULL
);
',1334159292,1334159292,6,3,1,0,0,0);
INSERT INTO "snippets" VALUES(6,'Creating Web Page Templates with PHP and Twig ','shell> pear channel-discover pear.twig-project.org
shell> pear install twig/Twig','<html>
  <head></head>
  <body>
  <h2>Account successfully created!</h2>

  <p>Hello {{ name }}</p>

  <p>Thank you for registering with us. Your account details are as follows: </p>

  <p style="margin-left: 10px">
  Username: {{ username }} <br/>
  Password: {{ password }}
  </p>

  <p>You''ve already been logged in, so go on in and have some fun!</p>
  </body>
</html>',1334165631,1334165631,1,3,0,0,0,0);
INSERT INTO "snippets" VALUES(7,'Getter / Setter implicites PHP class','Getter / Setter implicites PHP class','<?php

/*
 * Getter / Setter implicites PHP class
 */

class Dummy {

  protected $firstName = "";
  protected $lastName = "";

  function __set($prop, $value) {
    if (property_exists($this, $prop)):
      $propName = ucwords($prop);
      $setter = "set$propName";
      if (method_exists($this, $setter)):
        $this->$setter($value);
      else:
        $this->$prop = $value;
      endif;
    endif;
  }

  function setFirstName($value) {
    echo "setting Name = $value";
    $this->firstName = $value;
  }

}

$dummy = new Dummy();
$dummy->firstName = "Martin";
$dummy->lastName = "Circus";
var_dump($dummy);
?>
',1334186568,1334186568,1,3,0,0,0,0);
INSERT INTO "snippets" VALUES(8,'Activer Zend_Db_Profiler','Activer Zend_Db_Profiler','// dans le bootstrap.php
//Activer Zend_Db_Profiler
resources.db.params.profiler=true',1334586850,1334586850,1,3,0,0,0,0);
INSERT INTO "snippets" VALUES(9,'Zend Set default controller','Zend Set default controller','; in the application.ini file
resources.frontController.defaultControllerName="site"',1334587235,1334587235,1,3,0,0,0,0);
INSERT INTO "snippets" VALUES(10,'Zend : use Zend_Cache with Zend_Translate','Zend : use Zend_Cache with Zend_Translate','$cache = Zend_Cache::factory(''Core'',
                             ''File'',
                             $frontendOptions,
                             $backendOptions);
Zend_Translate::setCache($cache);
$translate = new Zend_Translate(
    array(
        ''adapter'' => ''gettext'',
        ''content'' => ''/path/to/translate.mo'',
        ''locale''  => ''en''
    )
);',1334594566,1334594566,1,3,0,0,0,0);
INSERT INTO "snippets" VALUES(11,'Zend framework : Access layout object','Zend framework : Access layout object','//Within view scripts: use the layout() view helper, 
//which returns the Zend_Layout
//instance registered with the front controller plugin.

<?php $layout = $this->layout(); ?>

//Within action controllers: use the layout() action helper, 
//which acts just like the view helper.

// Calling helper as a method of the helper broker:
$layout = $this->_helper->layout();
 
// Or, more verbosely:
$helper = $this->_helper->getHelper(''Layout'');
$layout = $helper->getLayoutInstance();

//Elsewhere: use the static method getMvcInstance(). 
//This will return the layout instance registered by the bootstrap resource.

$layout = Zend_Layout::getMvcInstance();

//Via the bootstrap: retrieve the layout resource, 
//which will be the Zend_Layout instance.

$layout = $bootstrap->getResource(''Layout'');',1334626165,1334626165,1,3,1,0,0,0);
INSERT INTO "snippets" VALUES(12,'Zend Translate : create a translate plugin','Zend Translate : create a translate plugin','<?php
class CMS_Application_Resource_Translate extends Zend_Application_Resource_ResourceAbstract{
  function init(){
    $options =$this->getOptions();
    $adapter = $options[''adapter''];
    $defaultTranslation = $options[''default''][''file''];
    $defaultLocale = $options[''default''][''locale''];
    $translate = new Zend_Translate($adapter,$defaultTranslation,$defaultLocale);
    foreach($options[''translation''] as $locale => $translation):
      $translate->addTranslation($translation,$locale);
    endforeach;
    Zend_Registry::set(''Zend_Translate'',$translate);
    return $translate;
  }
}
',1334673438,1334673438,1,3,1,0,0,0);
INSERT INTO "snippets" VALUES(13,'ZEND : Access view values from partialLoop','ZEND : Access view values from partialLoop','// in the view template:
 
$this->bla = ''blabla''; //value we will access
echo $this->partialLoop(''imageviews/thumbnails.phtml'',$this->searchResults);
 
//in the partialLoop template:
 
<?php echo $this->partialLoop()->view->bla // echo''s blabla ?>
 
//You can ofcourse also retrieve the view in the partialLoop as anywhere like this: 
$view = Zend_Layout::getMvcInstance()->getView();


',1334703572,1334703572,1,3,1,0,0,0);
INSERT INTO "snippets" VALUES(14,'Zend - Conditional validation of shipping address using Zend sub forms ','Zend - Conditional validation of shipping address using Zend sub forms ','
''http://www.designing4u.de/2011/07/conditional-validation-of-shipping-address-using-zend-sub-forms/''

/*Conditional validation of shipping address using Zend sub forms
Zend Framework documentation gives you an excellent example on how
 to use sub forms. Sub forms let you split the logic of your application
 into smaller parts, validate it on demand and after collecting all the 
information validate the whole entity. Pretty cool huh? Lately I was 
implementing a shopping cart. In the last part of the check out process 
the user has to provide the billing address and shipping address. 
Usually they are the same but sometimes they differ. Here is how
 I solved the conditional validation of the form fields for orders where shipping address differs.

For the brevity I removed some of the fields from the form and left 
only first name and last name just to demonstrate how your form should look like. 
I also removed validations, filters and decorators. In your application 
you should add all fields that are necessary in your checkout process 
and attach the corresponding validations to those fields.

The code is pretty simple. In the init method you have to initialize
 sub form for billing and sub form for shipping. You then add the 
fields to the sub forms, attach validations to the billing forms
 and the checkbox to the shipping sub form.
*/

<?php
/**
 * Application_Form_Address class
 *
 * Class is responsible for collecting the buyers address.
 *
 * @author Wojciech Gancarczyk <gancarczyk@gmail.com>
 */
class Application_Form_Address extends Zend_Form
{
    /**
     * Initializes the form and sets the elements.
     *
     * @return void
     */
    public function init()
    {
        $billing = new Zend_Form_SubForm();
        $this->addFields($billing)->attachValidators($billing);
 
        $shipping = new Zend_Form_SubForm();
        $differs = new Zend_Form_Element_Checkbox(''differs'');
        $differs->setLabel(''Shipping differs'')->setValue(''0'');
        $shipping->addElement($differs);
        $this->addFields($shipping);
 
        $this->addSubForms(array(
            ''billing'' => $billing,
            ''shipping'' => $shipping
        ));
 
        $submit = new Zend_Form_Element_Submit(''submit'');
        $this->addElement($submit);
    }
 
    /**
     * Add fields to the sub form.
     *
     * @param Zend_Form_SubForm $form
     * @return Application_Form_Address
     */
    public function addFields(Zend_Form_SubForm $form)
    {
        $firstname = new Zend_Form_Element_Text(''firstname'');
        $firstname->setLabel(''Firstname'');
        $form->addElement($firstname);
 
        $lastname = new Zend_Form_Element_Text(''lastname'');
        $lastname->setLabel(''Lastname'');
        $form->addElement($lastname);
 
        return $this;
    }
 
    /**
     * Attach validators to the fields in the sub form.
     *
     * @param Zend_Form_SubForm $form
     * @return void
     */
    public function attachValidators(Zend_Form_SubForm $form)
    {
        $form->getElement(''firstname'')->setRequired(true);
        $form->getElement(''lastname'')->setRequired(true);
    }
 
    /**
     * Overwrites the parent method and attaches
     * conditional validators only if shipping address
     * differs.
     *
     * @param array $data
     * @return bool
     */
    public function isValid($data)
    {
        $this->populate($data);
 
        $shipping = $this->getSubForm(''shipping'');
        if ((int) $shipping->getElement(''differs'')->getValue() === 1) {
            $this->attachValidators($shipping);
        }
 
        return parent::isValid($data);
    }
 
    /**
     * Process the data.
     *
     * @return void
     */
    public function process()
    {
        // do something with the data
    }
}
/*The interesting part is the isValid method, which overwrites
 the method in the parent class. Before the validation will 
be delegated to the parent class, the data form the request
 is populated in the form. If the value of checkbox differs 
changed to 1 (meaning the user wants to provide a different 
shipping address), the validations are attached to the shipping form.*/

public function addressAction()
{
    $form = new Application_Form_Address();
    if ($this->_request->isPost()) {
        if ($form->isValid($this->_request->getPost())) {
            $form->process();
            // do something ...
        }
    }
    $this->view->assign(array(''form'' => $form));
}
/*
As usually in your controller you would initialize the form,
 check if the request is a post request, validate the form 
and redisplay it if necessary. Go and try it out, if the
 differs checkbox won''t be clicked, only the billing form */
will be validated, in other case both of the form will be validated.',1335112666,1335112666,1,3,1,0,0,0);
INSERT INTO "snippets" VALUES(15,'Htaccess - RewriteBase','Htaccess - RewriteBase','RewriteEngine On
RewriteBase /urlfragment',1335317049,1335317049,36,3,1,0,0,0);
INSERT INTO "snippets" VALUES(16,'Zend - Autocomplete Control with ZendX_JQuery','Zend - Autocomplete Control with ZendX_JQuery','SIMPLE AUTO COMPLETE
--------------------
// in the layout head tag
<?=$this->headlink->appendStylesheet("...path to jquery ui stylesheet")?>
<?=$this->jQuery()->setVersion(''1.4.2'')->setUIVersion("1.8.2")?>

// in a view file
<h1>auto complete
<form>
<?=$this->autoCompleteElement?>
</form>

// in a controller action
$emt = new ZendX_JQuery_Form_Element_AutoComplete(''ac'');
$emt->setLabel(''Autocomplete'');
$emt->setJQueryParam(''data'',array(''Montreal'',''Chicago'',''Amsterdam'',''Boston'',''Albany''));
$this->view->autoCompleteElement = $emt;
',1335364193,1335364193,1,3,1,0,0,0);
INSERT INTO "snippets" VALUES(17,'Zend Framework -  Get the server url','How to get the server url in Zend Framework.','USING A VIEW HELPER

// application/views/scripts/index/index.phtml

<?=$this->serverUrl()?> // returns the server url',1335409183,1335409183,1,3,1,0,0,0);
INSERT INTO "snippets" VALUES(18,'Zend Framework - Create a captcha image ','How to create a captcha image form element','<?php
$captcha = new Zend_Form_Element_Captcha(''captcha'', array(
    ''autocomplete'' => ''off'',
    ''label'' => ''Entrez les 4 caractères affichés dans l\''image :'',
    ''maxlength'' => 4,
    ''size'' => 4,
    ''captcha'' => array(
        ''captcha'' => ''Image'',
        ''dotNoiseLevel'' => 50, // Valeur initiale = 100
        ''lineNoiseLevel'' => 2, // Valeur initiale = 5
        ''font'' => APPLICATION_PATH . ''/../fonts/arial.ttf'',
        ''fontSize'' => 28,
        ''imgDir'' => APPLICATION_PATH . ''/../public/captcha'',
        ''imgUrl'' => ''/captcha/'',
        ''timeout'' => 300,
        ''wordLen'' => 4
    )
));
?>',1335409746,1335409746,1,3,1,0,0,0);
INSERT INTO "snippets" VALUES(19,'Serialize form datas','How to serialize form datas','(function(formId, target) {
    var getForm = function() {
        return document.getElementById(formId);
    };
    var getTarget = function() {
        return document.getElementById(target);
    };
    var makeTextNode = function(_string) {
        return document.createTextNode(_string);
    };
    var makeDatas = function(form) {
        HTMLCollection.prototype.map = Array.prototype.map;
        return form.elements.map(function(row, i) {
            var o = {};
            o[row.name] = row.value;
            return o
        });
    }
    getTarget().appendChild(makeTextNode(JSON.stringify(makeDatas(getForm()))));
})("tabledata", "pieChart");​',1335452894,1335452894,2,3,1,0,0,0);
INSERT INTO "snippets" VALUES(20,'Zend framework : Configure Mail class','Zend framework : Configure Mail class',';---------------------------------
;@NOTE @ZEND email configuration |
;---------------------------------
resources.mail.transport.type       = smtp
resources.mail.transport.ssl        = ssl        
resources.mail.transport.port       = port
resources.mail.transport.host       = host
resources.mail.transport.auth       = login
resources.mail.transport.username   = username   
resources.mail.transport.password   = password   
resources.mail.transport.register   = true ; True by default
resources.mail.defaultFrom.email    = support@dsnippet.com
resources.mail.defaultFrom.name     = Support
resources.mail.defaultReplyTo.email = support@dsnippet.com
resources.mail.defaultReplyTo.name  = Support',1335500720,1335500720,1,6,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(21,'DL, DT and DD','How to use DL, DT and DD','<dl>
 <dt>Terme 1 à définir</dt>
  <dd>Voici la définition 
  pour le terme 1</dd>
 <dt>Terme 2 à définir</dt>
  <dd>Voici la définition 
  pour le terme 2</dd>
</dl> ',1335574687,1335574687,4,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(22,'Sqlite - Create a timestamp','How to create a timestamp in SQLite.','select strftime(''%s'',''now'');',1335762396,1335762396,6,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(23,'jQuery UI- Progress bar','How to set up a progress bar with jQuery UI','<meta charset="utf-8">
	<style>
	.ui-progressbar-value { background-image: url(images/pbar-ani.gif); }
	</style>
	<script>
	$(function() {
		$( "#progressbar" ).progressbar({
			value: 59
		});
	});
	</script>
<div class="demo">
<div id="progressbar"></div>',1335896180,1335896180,2,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(24,'Underscore - Bind function','How to use underscore bind function','_.bind(function, object, [*arguments]) 
//Bind a function to an object, meaning that whenever the function is called, the value of 
//this will be the object. Optionally, bind arguments to the function to pre-fill them, 
//also known as partial application.

var func = function(greeting){ return greeting + '': '' + this.name };
func = _.bind(func, {name : ''moe''}, ''hi'');
func();
=> ''hi: moe''',1335896441,1335896441,2,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(25,'Zend - Configure Zend Cache','Zend - Configure Zend Cache','// in application.ini file
resources.cachemanager.database.frontend.name = Core
resources.cachemanager.database.frontend.customFrontendNaming = false
resources.cachemanager.database.frontend.options.lifetime = 7200
resources.cachemanager.database.frontend.options.automatic_serialization = true
resources.cachemanager.database.backend.name = File
resources.cachemanager.database.backend.customBackendNaming = false
resources.cachemanager.database.backend.options.cache_dir = "/path/to/cache"
resources.cachemanager.database.frontendBackendAutoload = false

//get the cache manager in the application

$manager = $this->getFrontController()
                ->getParam(''bootstrap'')
                ->getResource(''cachemanager'')
                ->getCacheManager();
$dbCache = $manager->getCache(''database'');',1335901693,1335901693,1,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(26,'Hello world','Hello world in AS3.','trace("Hello world!");

import flash.text.TextField;
var champ:TextField = new TextField();
champ.text = "Hello World!";
this.addChild(champ);',1335924727,1335924727,3,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(27,'Hello world in Bash','Hello world in Bash','#!/bin/bash
echo Hello world',1336020199,1336020199,11,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(28,'Hello world in C','Hello world in C','#include <stdio.h>
 
int main(void)// ou int (argc, char *argv[]) 
{
    printf("Hello world!");
    return 0;
}',1336020467,1336020467,16,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(29,'Class definition','Class definition','class Animal
  constructor: (@name) ->

  move: (meters) ->
    alert @name + " moved #{meters}m."

class Snake extends Animal
  move: ->
    alert "Slithering..."
    super 5

class Horse extends Animal
  move: ->
    alert "Galloping..."
    super 45

sam = new Snake "Sammy the Python"
tom = new Horse "Tommy the Palomino"

sam.move()
tom.move()
',1336026058,1336026058,14,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(30,'Zend - decoding Json string','How to decode json string with Zend_Json','// Obtention d''une valeur
$phpNatif = Zend_Json::decode($valeurCodee);
 
// Codage pour renvoi au client :
$json = Zend_Json::encode($phpNatif);',1336270335,1336270335,1,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(31,'Vim - how to write a vimrc file','Vim - how to write a vimrc file','"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugin
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it''s possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" Fast editing of the .vimrc
map <leader>e :e! ~/.vim_runtime/vimrc<cr>

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vim_runtime/vimrc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7

set wildmenu "Turn on WiLd menu

set ruler "Always show current position

set cmdheight=2 "The commandbar height

set hid "Change buffer - without saving

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching
set smartcase

set hlsearch "Highlight search things

set incsearch "Make search act like search in modern browsers
set nolazyredraw "Don''t redraw while executing macros 

set magic "Set magic on, for regular expressions

set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl

" Set font according to system
if MySys() == "mac"
  set gfn=Menlo:h14
  set shell=/bin/bash
elseif MySys() == "windows"
  set gfn=Bitstream\ Vera\ Sans\ Mono:h10
elseif MySys() == "linux"
  set gfn=Monospace\ 10
  set shell=/bin/bash
endif

if has("gui_running")
  set guioptions-=T
  set t_Co=256
  set background=dark
  colorscheme peaksea
  set nonu
else
  colorscheme zellner
  set background=dark

  set nonu
endif

set encoding=utf8
try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
try
    if MySys() == "windows"
      set undodir=C:\Windows\Temp
    else
      set undodir=~/.vim_runtime/undodir
    endif

    set undofile
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set lbr
set tw=500

set ai "Auto indent
set si "Smart indet
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch(''f'')<CR>
vnoremap <silent> # :call VisualSearch(''b'')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch(''gv'')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>


function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", ''\\/.*$^~[]'')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == ''b''
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == ''gv''
        call CmdLine("vimgrep " . ''/''. l:pattern . ''/'' . '' **/*.'')
    elseif a:direction == ''f''
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Useful on some European keyboards
map ½ $
imap ½ $
vmap ½ $
cmap ½ $


func! Cwd()
  let cwd = getcwd()
  return "e " . cwd 
endfunc

func! DeleteTillSlash()
  let g:cmd = getcmdline()
  if MySys() == "linux" || MySys() == "mac"
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  else
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
  endif
  if g:cmd == g:cmd_edited
    if MySys() == "linux" || MySys() == "mac"
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    else
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
    endif
  endif
  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <c-space> ?
map <silent> <leader><cr> :noh<cr>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" Use the arrows to something usefull
map <right> :bn<cr>
map <left> :bp<cr>

" Tab configuration
map <leader>tn :tabnew<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>


command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Specify the behavior when switching between buffers 
try
  set switchbuf=usetab
  set stal=2
catch
endtry


""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c


function! CurDir()
    let curdir = substitute(getcwd(), ''/Users/amir/'', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return ''PASTE MODE  ''
    else
        return ''''
    endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a''<esc>`<i''<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", '', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^

"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m''>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m''<-2<cr>`>my`<mzgv`yo`z

if MySys() == "mac"
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

set guitablabel=%t


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It''s super useful!
map <leader>cc :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>


""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
map <leader>o :BufExplorer<cr>


""""""""""""""""""""""""""""""
" => Minibuffer plugin
""""""""""""""""""""""""""""""
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplVSplit = 25
let g:miniBufExplSplitBelow=1

let g:bufExplorerSortBy = "name"

autocmd BufRead,BufNew :call UMiniBufExplorer

map <leader>u :TMiniBufExplorer<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def


""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <c-t> AJS.log();<esc>hi
au FileType javascript imap <c-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r return
au FileType javascript inoremap <buffer> $f //--- PH ----------------------------------------------<esc>FP2xi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
    return substitute(getline(v:foldstart), ''{.*'', ''{...}'', '''')
    endfunction
    setl foldtext=FoldText()
endfunction


""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>


""""""""""""""""""""""""""""""
" => Command-T
""""""""""""""""""""""""""""""
let g:CommandTMaxHeight = 15
set wildignore+=*.o,*.obj,.git,*.pyc
noremap <leader>j :CommandT<cr>
noremap <leader>y :CommandTFlush<cr>


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = ''RCS CVS SCCS .svn generated''
set grepprg=/bin/grep\ -nH



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>''tzt''m

"Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>
au BufRead,BufNewFile ~/buffer iab <buffer> xh1 ===========================================

map <leader>pp :setlocal paste!<cr>

map <leader>bb :cd ..<cr>',1336274917,1336274917,11,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(33,'Array Slicing and Splicing with Ranges','Array Slicing and Splicing with Ranges','#Array Slicing and Splicing with Ranges

#Ranges can also be used to extract slices of arrays. With two dots (3..6), the range is inclusive 
#(3, 4, 5, 6); with three dots (3...6), the range excludes the end (3, 4, 5). Slices indices have 
#useful defaults. An omitted first index defaults to zero and an omitted second index defaults to 
#the size of the array.

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]

start   = numbers[0..2]

middle  = numbers[3...6]

end     = numbers[6..]

copy    = numbers[..]',1336276155,1336276155,14,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(34,'Underscore - Object Functions','Underscore - Object Functions','Object Functions

keys_.keys(object) 
//Retrieve all the names of the object''s properties.

_.keys({one : 1, two : 2, three : 3}); => ["one", "two", "three"]

values_.values(object) 

//Return all of the values of the object''s properties.

_.values({one : 1, two : 2, three : 3}); => [1, 2, 3]

functions_.functions(object) Alias: methods 

//Returns a sorted list of the names of every method in an object — 
//that is to say, the name of every function property of the object.

_.functions(_); => ["all", "any", "bind", "bindAll", "clone", "compact", "compose" ...

extend_.extend(destination, *sources) 

//Copy all of the properties in the source objects over to the destination object, 
//and return the destination object. It''s in-order, so the last source will 
//override properties of the same name in previous arguments.

_.extend({name : ''moe''}, {age : 50}); => {name : ''moe'', age : 50}

pick_.pick(object, *keys) 

//Return a copy of the object, filtered to only have values 
//for the whitelisted keys (or array of valid keys).

_.pick({name : ''moe'', age: 50, userid : ''moe1''}, ''name'', ''age''); => {name : ''moe'', age : 50}

defaults_.defaults(object, *defaults) 

//Fill in missing properties in object with default values 
//from the defaults objects, and return the object.
// As soon as the property is filled, further defaults will have no effect.

var iceCream = {flavor : "chocolate"};

_.defaults(iceCream, {flavor : "vanilla", sprinkles : "lots"}); => {flavor : "chocolate", sprinkles : "lots"}

clone_.clone(object) 

// Create a shallow-copied clone of the object. 
// Any nested objects or arrays will be copied by reference, not duplicated.

_.clone({name : ''moe''}); => {name : ''moe''};

tap_.tap(object, interceptor) 

// Invokes interceptor with the object, and then returns object. 
// The primary purpose of this method is to "tap into" a method chain,
//  in order to perform operations on intermediate results within the chain.

_.chain([1,2,3,200])
  .filter(function(num) { return num % 2 == 0; })
  .tap(alert)
  .map(function(num) { return num * num })
  .value();
=> // [2, 200] (alerted)
=> [4, 40000]

has_.has(object, key) 

//Does the object contain the given key? 
// Identical to object.hasOwnProperty(key),
// but uses a safe reference to the hasOwnProperty function,
// in case it''s been overridden accidentally.

_.has({a: 1, b: 2, c: 3}, "b"); => true

isEqual_.isEqual(object, other) 
Performs an optimized deep comparison between the two objects, to determine if they should be considered equal.

var moe   = {name : ''moe'', luckyNumbers : [13, 27, 34]};
var clone = {name : ''moe'', luckyNumbers : [13, 27, 34]};
moe == clone;
=> false
_.isEqual(moe, clone);
=> true
isEmpty_.isEmpty(object) 
Returns true if object contains no values.

_.isEmpty([1, 2, 3]);
=> false
_.isEmpty({});
=> true
isElement_.isElement(object) 
Returns true if object is a DOM element.

_.isElement(jQuery(''body'')[0]);
=> true
isArray_.isArray(object) 
Returns true if object is an Array.

(function(){ return _.isArray(arguments); })();
=> false
_.isArray([1,2,3]);
=> true
isObject_.isObject(value) 
Returns true if value is an Object.

_.isObject({});
=> true
_.isObject(1);
=> false
isArguments_.isArguments(object) 
Returns true if object is an Arguments object.

(function(){ return _.isArguments(arguments); })(1, 2, 3);
=> true
_.isArguments([1,2,3]);
=> false
isFunction_.isFunction(object) 
Returns true if object is a Function.

_.isFunction(alert);
=> true
isString_.isString(object) 
Returns true if object is a String.

_.isString("moe");
=> true
isNumber_.isNumber(object) 
Returns true if object is a Number (including NaN).

_.isNumber(8.4 * 5);
=> true
isFinite_.isFinite(object) 
Returns true if object is a finite Number.

_.isFinite(-101);
=> true

_.isFinite(-Infinity);
=> false
isBoolean_.isBoolean(object) 
Returns true if object is either true or false.

_.isBoolean(null);
=> false
isDate_.isDate(object) 
Returns true if object is a Date.

_.isDate(new Date());
=> true
isRegExp_.isRegExp(object) 
Returns true if object is a RegExp.

_.isRegExp(/moe/);
=> true
isNaN_.isNaN(object) 
Returns true if object is NaN.
Note: this is not the same as the native isNaN function, which will also return true if the variable is undefined.

_.isNaN(NaN);
=> true
isNaN(undefined);
=> true
_.isNaN(undefined);
=> false
isNull_.isNull(object) 
Returns true if the value of object is null.

_.isNull(null);
=> true
_.isNull(undefined);
=> false
isUndefined_.isUndefined(variable) 
Returns true if variable is undefined.

_.isUndefined(window.missingVariable);
=> true',1336279203,1336279203,2,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(35,'Destructuring Assignment','Destructuring Assignment','theBait   = 1000
theSwitch = 0

[theBait, theSwitch] = [theSwitch, theBait]


weatherReport = (location) ->
  # Make an Ajax request to fetch the weather...
  [location, 72, "Mostly Sunny"]

[city, temp, forecast] = weatherReport "Berkeley, CA"
',1336279830,1336279830,14,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(36,'Function binding','Function binding','Account = (customer, cart) ->
  @customer = customer
  @cart = cart

  $(''.shopping_cart'').bind ''click'', (event) =>
    @customer.purchase @cart',1336281906,1336281906,14,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(37,'Splats','How to user Splats','gold = silver = rest = "unknown"

awardMedals = (first, second, others...) ->
  gold   = first
  silver = second
  rest   = others

contenders = [
  "Michael Phelps"
  "Liu Xiang"
  "Yao Ming"
  "Allyson Felix"
  "Shawn Johnson"
  "Roman Sebrle"
  "Guo Jingjing"
  "Tyson Gay"
  "Asafa Powell"
  "Usain Bolt"
]

awardMedals contenders...

alert "Gold: " + gold
alert "Silver: " + silver
alert "The Field: " + rest',1336282011,1336282011,14,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(39,'GIT -  A web-focused Git workflow','GIT - A web-focused Git workflow','A web-focused Git workflow
After months of looking, struggling through Git-SVN glitches and letting things roll around in my head, I’ve finally arrived at a web-focused Git workflow that’s simple, flexible and easy to use.

Some key advantages:

Pushing remote changes automatically updates the live site
Server-based site edits won’t break history
Simple, no special commit rules or requirements
Works with existing sites, no need to redeploy or move files
Overview
The key idea in this system is that the web site exists on the server as a pair of repositories; a bare repository alongside a conventional repository containing the live site. Two simple Git hooks link the pair, automatically pushing and pulling changes between them.



The two repositories:

Hub is a bare repository. All other repositories will be cloned from this.
Prime is a standard repository, the live web site is served from its working directory.
Using the pair of repositories is simple and flexible. Remote clones with ssh-access can update the live site with a simple git push to Hub. Any files edited directly on the server are instantly mirrored into Hub upon commit. The whole thing pretty much just works — whichever way it’s used.

Getting ready

Obviously Git is required on the server and any local machines. My shared web host doesn’t offer Git, but it’s easy enough to install Git yourself.

If this is the first time running Git on your webserver, remember to setup your global configuration info. I set a different Git user.name to help distinguish server-based changes in project history.

$ git config --global user.name "Joe, working on the server"
Getting started
The first step is to initialize a new Git repository in the live web site directory on the server, then to add and commit all the site’s files. This is the Prime repository and working copy. Even if history exists in other places, the contents of the live site will be the baseline onto which all other work is merged.

$ cd ~/www
$ git init
$ git add .
$ git commit -m"initial import of pre-existing web files"
Initializing in place also means there is no downtime or need to re-deploy the site, Git just builds a repository around everything that’s already there.

With the live site now safely in Git, create a bare repository outside the web directory, this is Hub.

$ cd; mkdir site_hub.git; cd site_hub.git
$ git --bare init
Initialized empty Git repository in /home/joe/site_hub.git
Then, from inside Prime’s working directory, add Hub as a remote and push Prime’s master branch:

$ cd ~/www
$ git remote add hub ~/site_hub.git
$ git remote show hub
* remote hub
  URL: /home/joe/site_hub.git
$ git push hub master
Hooks
Two simple Git hooks scripts keep Hub and Prime linked together.

An oft-repeated rule of Git is to never push into a repository that has a work tree attached to it. I tried it, and things do get weird fast. The hub repository exists for this reason. Instead of pushing changes to Prime from Hub, which wouldn’t affect the working copy anyway, Hub uses a hook script which tells Prime to pull changes from Hub.

post-update – Hub repository
This hook is called when Hub receives an update. The script changes directories to the Prime repository working copy then runs a pull from Prime. Pushing changes doesn’t update a repository’s working copy, so it’s necessary to execute this from inside the working copy itself.

#!/bin/sh

echo
echo "**** Pulling changes into Prime [Hub''s post-update hook]"
echo

cd $HOME/www || exit
unset GIT_DIR
git pull hub master

exec git-update-server-info
post-commit – Prime repository
This hook is called after every commit to send the newly commited changes back up to Hub. Ideally, it’s not common to make changes live on the server, but automating this makes sure site history won’t diverge and create conflicts.

#!/bin/sh

echo
echo "**** pushing changes to Hub [Prime''s post-commit hook]"
echo

git push hub
With this hook in place, all changes made to Prime’s master branch are immediately available from Hub. Other branches will also be cloned, but won’t affect the site. Because all remote repository access is via SSH urls, only users with shell access to the web server will be able to push and trigger a site update.

Conflicts
This repository-hook arrangement makes it very difficult to accidentally break the live site. Since every commit to Prime is automatically pushed to Hub, all conflicts will be immediately visible to the clones when pushing an update.

However there are a few situations where Prime can diverge from Hub which will require additional steps to fix. If an uncommitted edit leaves Prime in a dirty state, Hub’s post-update pull will fail with an “Entry ‘foo’ not uptodate. Cannot merge.” warning. Committing changes will clean up Prime’s working directory, and the post-update hook will then merge the un-pulled changes.

If a conflict occurs where changes to Prime can’t be merged with Hub, I’ve found the best solution is to push the current state of Prime to a new branch on Hub. The following command, issued from inside Prime, will create a remote “fixme” branch based on the current contents of Prime:

$ git push hub master:refs/heads/fixme
Once that’s in Hub, any remote clone can pull down the new branch and resolve the merge. Trying to resolve a conflict on the server would almost certainly break the site due to Git’s conflict markers.

Housekeeping
Prime’s .git folder is at the root level of the web site, and is probably publicly accessible. To protect the folder and prevent unwanted clones of the repository, add the following to your top-level .htaccess file to forbid web access:

# deny access to the top-level git repository:
RewriteEngine On
RewriteRule \.git - [F,L]
Troubleshooting
If you’re seeing this error when trying to push to a server repository:

git-receive-pack: command not found
fatal: The remote end hung up unexpectedly
Add export PATH=${PATH}:~/bin to your .bashrc file on the server. Thanks to Robert for finding and posting the fix.

Links
These didn’t fit in anywhere else:

Toolman Tim has a very good introductory walkthrough of setting up a new remote git repository.
This ended up being somewhat similar to the update mechanism in Ikiwiki, wish I’d found that page earlier.
Getting a static web site organized with git came up with a different solution, but calling git reset --hard from a hook on the server could cause a lot of trouble when committing server-side changes.',1336283909,1336283909,11,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(40,'How to install Git on a shared host ','How to install Git on a shared host ','// source : http://joemaller.com/908/how-to-install-git-on-a-shared-host/
How to install Git on a shared host
(regularly updated)

Installing Git on a shared hosting account is simple, the installation is fast and like most things Git, it just works.

As with my previous Subversion on shared hosting post, this will be a barebones install. The purpose of this installation is to be able to push changes from remote repositories into the hosted repo, where the hosted repository may also serve as the source directory of the live website. Like this.

Prerequisites
The only two things you absolutely must have are shell access to the account and permission to use GCC on the server. Check both with the following command:

$ ssh joe@webserver ''gcc --version''
gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-50)
[...]
If GCC replies with a version number, you should be able to install Git. SSH into your server and let’s get started!

If you see something like /usr/bin/gcc: Permission denied you don’t have access to the GCC compiler and won’t be able to build the Git binaries from source. Find another hosting company.

Update your $PATH
None of this will work if you don’t update the $PATH environment variable. In most cases, this is set in .bashrc. Using .bashrc instead of .bash_profile updates $PATH for interactive and non-interactive sessions–which is necessary for remote Git commands. Edit .bashrc and add the following line:

export PATH=$HOME/opt/bin:$PATH
Be sure ‘~/opt/bin’ is at the beginning since $PATH is searched from left to right; to execute local binaries first, their location has to appear first. Depending on your server’s configuration there could be a lot of other stuff in there, including duplicates.

Double-check this by sourcing the file and echoing $PATH:

$ source ~/.bashrc
$ echo $PATH
/home/joe/opt/bin:/usr/local/bin:/bin:/usr/bin
Verify that the remote path was updated by sending a remote command like this (from another connection):

$ ssh joe@webserver ''echo $PATH''
/home/joe/opt/bin:/usr/local/bin:/bin:/usr/bin
Note: Installing into the ~/opt directory keeps the home folder cleaner and is where add-on applications are customarily installed on Unix systems.

Installing Git
SSH into your webserver. I created a source directory to hold the files and make cleanup easier:

$ cd
$ mkdir src
$ cd src
Grab the most current source tarballs from the Git site. At the time this post was last updated, the most recent version was v1.7.6:

$ curl -LO http://kernel.org/pub/software/scm/git/git-1.7.6.tar.bz2
Untar the archive and cd into the new directory:

$ tar -xjvf git-1.7.6.tar.bz2
$ cd git-1.7.6
This next step is the only one that really seems to matter with regards to shared hosting. The Configure script needs to be told where to install, and because we’re on a shared host, Git’s files should be put somewhere in our home directory:

$ ./configure --prefix=$HOME/opt
[words...]
Lastly, make and install:

$ make && make install
[lots of words...]
That should be it, check your installed version like this:

$ git --version
git version 1.7.6
It''s now safe to delete the src folder which contained the download and source files.

Note that these instructions do not install Git''s documentation man pages. Also, these instructions appear to work exactly the same on Mac OS X, though the installer package is way easier and includes documentation.

My preferred shared hosting providers are A2 Hosting and WebFaction.',1336283941,1336283941,11,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(41,'Loops and Comprehension','Loops and Comprehension','# Eat lunch.
eat food for food in [''toast'', ''cheese'', ''wine'']

# Fine five course dining.
courses = [''greens'', ''caviar'', ''truffles'', ''roast'', ''cake'']
menu i + 1, dish for dish, i in courses

# Health conscious meal.
foods = [''broccoli'', ''spinach'', ''chocolate'']
eat food for food in foods when food isnt ''chocolate''',1336284202,1336284202,14,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(43,'Cake, and Cakefiles','Cake, and Cakefiles','Cake, and Cakefiles

/* 
CoffeeScript includes a (very) simple build system similar to Make and Rake. Naturally, it''s called Cake, and is used for the tasks that build and test the CoffeeScript language itself. Tasks are defined in a file named Cakefile, and can be invoked by running cake [task] from within the directory. To print a list of all the tasks and options, just type cake.

Task definitions are written in CoffeeScript, so you can put arbitrary code in your Cakefile. Define a task with a name, a long description, and the function to invoke when the task is run. If your task takes a command-line option, you can define the option with short and long flags, and it will be made available in the options object. Here''s a task that uses the Node.js API to rebuild CoffeeScript''s parser:
*/

fs = require ''fs''

option ''-o'', ''--output [DIR]'', ''directory for compiled code''

task ''build:parser'', ''rebuild the Jison parser'', (options) ->
  require ''jison''
  code = require(''./lib/grammar'').parser.generate()
  dir  = options.output or ''lib''
  fs.writeFile "#{dir}/parser.js", code

/*

If you need to invoke one task before another — for example, running  build before test, you can use the invoke function:  invoke ''build''. Cake tasks are a minimal way to expose your CoffeeScript functions to the command line, so don''t expect any fanciness built-in. If you need dependencies, or async callbacks, it''s best to put them in your code itself — not the cake task.
*/',1336307587,1336307587,14,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(45,'Array functions','Array functions ','//Fonctions sur les tableaux

// in french

Voir aussi is_array(), explode(), implode(), split(), preg_split() et unset().


array_change_key_case # Change la casse des clés d''un tableau

array_chunk # Sépare un tableau en tableaux de taille inférieure

array_combine # Crée un tableau à partir de deux autres tableaux
array_count_values # Compte le nombre de valeurs d''un tableau
array_diff_assoc # Calcule la différence de deux tableaux, en prenant aussi en compte les clés
array_diff_key # Calcule la différence de deux tableaux en utilisant les clés pour comparaison
array_diff_uassoc # Calcule la différence entre deux tableaux associatifs, à l''aide d''une fonction de rappel
array_diff_ukey # Calcule la différence entre deux tableaux en utilisant une fonction de rappel sur les clés pour comparaison
array_diff # Calcule la différence entre deux tableaux
array_fill_keys # Remplit un tableau avec des valeurs, en spécifiant les clés
array_fill # Remplit un tableau avec une même valeur
array_filter # Filtre les éléments d''un tableau grâce à une fonction utilisateur
array_flip # Remplace les clés par les valeurs, et les valeurs par les clés
array_intersect_assoc # Calcule l''intersection de deux tableaux avec des tests sur les index
array_intersect_key # Calcule l''intersection de deux tableaux en utilisant les clés pour comparaison
array_intersect_uassoc # Calcule l''intersection de deux tableaux avec des tests sur les index, compare les index en utilisant une fonction de rappel
array_intersect_ukey # Calcule l''intersection de deux tableaux en utilisant une fonction de rappel sur les clés pour comparaison
array_intersect # Calcule l''intersection de tableaux
array_key_exists # Vérifie si une clé existe dans un tableau
array_keys # Retourne toutes les clés ou un ensemble des clés d''un tableau
array_map # Applique une fonction sur les éléments d''un tableau
array_merge_recursive # Combine plusieurs tableaux ensemble, récursivement
array_merge # Fusionne plusieurs tableaux en un seul
array_multisort # Trie les tableaux multidimensionnels
array_pad # Complète un tableau avec une valeur jusqu''à la longueur spécifiée
array_pop # Dépile un élément de la fin d''un tableau
array_product # Calcule le produit des valeurs du tableau
array_push # Empile un ou plusieurs éléments à la fin d''un tableau
array_rand # Prend une ou plusieurs valeurs, au hasard dans un tableau
array_reduce # Réduit itérativement un tableau
array_replace_recursive # Replaces elements from passed arrays into the first array recursively
array_replace # Remplace les éléments d''un tableau par ceux d''autres tableaux
array_reverse # Inverse l''ordre des éléments d''un tableau
array_search # Recherche dans un tableau la clé associée à une valeur
array_shift # Dépile un élément au début d''un tableau
array_slice # Extrait une portion de tableau
array_splice # Efface et remplace une portion de tableau
array_sum # Calcule la somme des valeurs du tableau
array_udiff_assoc # Calcule la différence entre des tableaux avec vérification des index, compare les données avec une fonction de rappel
array_udiff_uassoc # Calcule la différence de deux tableaux associatifs, compare les données et les index avec une fonction de rappel
array_udiff # Calcule la différence entre deux tableaux en utilisant une fonction rappel
array_uintersect_assoc # Calcule l''intersection de deux tableaux avec des tests sur l''index, compare les données en utilisant une fonction de rappel
array_uintersect_uassoc # Calcule l''intersection de deux tableaux avec des tests sur l''index, compare les données et les indexes des deux tableaux en utilisant une fonction de rappel
array_uintersect # Calcule l''intersection de deux tableaux, compare les données en utilisant une fonction de rappel
array_unique # Dédoublonne un tableau
array_unshift # Empile un ou plusieurs éléments au début d''un tableau
array_values # Retourne toutes les valeurs d''un tableau
array_walk_recursive # Applique une fonction de rappel récursivement à chaque membre d''un tableau
array_walk # Exécute une fonction sur chacun des éléments d''un tableau
array # Crée un tableau
arsort # Trie un tableau en ordre inverse
asort # Trie un tableau et conserve l''association des index
compact # Crée un tableau à partir de variables et de leur valeur
count # Compte tous les éléments d''un tableau ou quelque chose d''un objet
current # Retourne l''élément courant du tableau
each # Retourne chaque paire clé/valeur d''un tableau
end # Positionne le pointeur de tableau en fin de tableau
extract # Importe les variables dans la table des symboles
in_array # Indique si une valeur appartient à un tableau
key # Retourne une clé d''un tableau associatif
krsort # Trie un tableau en sens inverse et suivant les clés
ksort # Trie un tableau suivant les clés
list # Assigne des variables comme si elles étaient un tableau
natcasesort # Trie un tableau avec l''algorithme à "ordre naturel" insensible à la casse
natsort # Trie un tableau avec l''algorithme à "ordre naturel"
next # Avance le pointeur interne d''un tableau
pos # Alias de current
prev # Recule le pointeur courant de tableau
range # Crée un tableau contenant un intervalle d''éléments
reset # Remet le pointeur interne de tableau au début
rsort # Trie un tableau en ordre inverse
shuffle # Mélange les éléments d''un tableau
sizeof # Alias de count
sort # Trie un tableau
uasort # Trie un tableau en utilisant une fonction de rappel
uksort # Trie un tableau par ses clés en utilisant une fonction de rappel
usort # Trie un tableau en utilisant une fonction de comparaison
',1336307788,1336307788,1,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(48,'CSS Wrap - white-space','CSS Wrap - white-space','Default is normal 

    white-space: none;
    white-space: nowrap;
    white-space: pre;
    white-space: pre-wrap;      /* CSS 2.1 */
    white-space: pre-line;      /* CSS 2.1 */
    white-space: inherit;',1336308452,1336308452,5,3,1,0,'FALSE',0);
INSERT INTO "snippets" VALUES(49,'Mediator pattern','Mediator pattern','/*
The mediator pattern defines an object that encapsulates how a set of objects interact. This pattern is considered to be a behavioral pattern due to the way it can alter the program''s running behavior.
Usually a program is made up of a (sometimes large) number of classes. So the logic and computation is distributed among these classes. However, as more classes are developed in a program, especially during maintenance and/or refactoring, the problem of communication between these classes may become more complex. This makes the program harder to read and maintain. Furthermore, it can become difficult to change the program, since any change may affect code in several other classes.
With the mediator pattern, communication between objects is encapsulated with a mediator object. Objects no longer communicate directly with each other, but instead communicate through the mediator. This reduces the dependencies between communicating objects, thereby lowering the coupling.


The essence of the Mediator Pattern is to "Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently. "

*/

import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
 
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
 
//Colleague interface
interface Command {
    void execute();
}
 
//Abstract Mediator
interface IMediator {
    void book();
    void view();
    void search();
    void registerView(BtnView v);
    void registerSearch(BtnSearch s);
    void registerBook(BtnBook b);
    void registerDisplay(LblDisplay d);
}
 
//Concrete mediator
class Mediator implements IMediator {
 
    BtnView btnView;
    BtnSearch btnSearch;
    BtnBook btnBook;
    LblDisplay show;
 
    //....
    void registerView(BtnView v) {
        btnView = v;
    }
 
    void registerSearch(BtnSearch s) {
        btnSearch = s;
    }
 
    void registerBook(BtnBook b) {
        btnBook = b;
    }
 
    void registerDisplay(LblDisplay d) {
        show = d;
    }
 
    void book() {
        btnBook.setEnabled(false);
        btnView.setEnabled(true);
        btnSearch.setEnabled(true);
        show.setText("booking...");
    }
 
    void view() {
        btnView.setEnabled(false);
        btnSearch.setEnabled(true);
        btnBook.setEnabled(true);
        show.setText("viewing...");
    }
 
    void search() {
        btnSearch.setEnabled(false);
        btnView.setEnabled(true);
        btnBook.setEnabled(true);
        show.setText("searching...");
    }
 
}
 
//A concrete colleague
class BtnView extends JButton implements Command {
 
    IMediator med;
 
    BtnView(ActionListener al, IMediator m) {
        super("View");
        addActionListener(al);
        med = m;
        med.registerView(this);
    }
 
    public void execute() {
        med.view();
    }
 
}
 
//A concrete colleague
class BtnSearch extends JButton implements Command {
 
    IMediator med;
 
    BtnSearch(ActionListener al, IMediator m) {
        super("Search");
        addActionListener(al);
        med = m;
        med.registerSearch(this);
    }
 
    public void execute() {
        med.search();
    }
 
}
 
//A concrete colleague
class BtnBook extends JButton implements Command {
 
    IMediator med;
 
    BtnBook(ActionListener al, IMediator m) {
        super("Book");
        addActionListener(al);
        med = m;
        med.registerBook(this);
    }
 
    public void execute() {
        med.book();
    }
 
}
 
class LblDisplay extends JLabel {
 
    IMediator med;
 
    LblDisplay(IMediator m) {
        super("Just start...");
        med = m;
        med.registerDisplay(this);
        setFont(new Font("Arial", Font.BOLD, 24));
    }
 
}
 
class MediatorDemo extends JFrame implements ActionListener {
 
    IMediator med = new Mediator();
 
    MediatorDemo() {
        JPanel p = new JPanel();
        p.add(new BtnView(this, med));
        p.add(new BtnBook(this, med));
        p.add(new BtnSearch(this, med));
        getContentPane().add(new LblDisplay(med), "North");
        getContentPane().add(p, "South");
        setSize(400, 200);
        setVisible(true);
    }
 
    public void actionPerformed(ActionEvent ae) {
        Command comd = (Command) ae.getSource();
        comd.execute();
    }
 
    public static void main(String[] args) {
        new MediatorDemo();
    }
 
}

/*
Participants

Mediator - defines the interface for communication between Colleague objects
ConcreteMediator - implements the Mediator interface and coordinates communication between Colleague objects. It is aware of all the Colleagues and their purpose with regards to inter communication.
ConcreteColleague - communicates with other Colleagues through its Mediator
*/',1336371358,1336371358,10,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(50,'Proxy pattern','Proxy pattern','/*
In computer programming, the proxy pattern is a software design pattern.
A proxy, in its most general form, is a class functioning as an interface to something else. The proxy could interface to anything: a network connection, a large object in memory, a file, or some other resource that is expensive or impossible to duplicate.
A well-known example of the proxy pattern is a reference counting pointer object.
In situations where multiple copies of a complex object must exist, the proxy pattern can be adapted to incorporate the flyweight pattern in order to reduce the application''s memory footprint. Typically, one instance of the complex object and multiple proxy objects are created, all of which contain a reference to the single original complex object. Any operations performed on the proxies are forwarded to the original object. Once all instances of the proxy are out of scope, the complex object''s memory may be deallocated.
*/

/*
The following Java example illustrates the "virtual proxy" pattern.[clarification needed] The ProxyImage class is used to access a remote method.
*/

interface Image {
    void displayImage();
}
 
// on System A 
class RealImage implements Image {
    private String filename;
 
    public RealImage(String filename) { 
        this.filename = filename;
        loadImageFromDisk();
    }
 
    private void loadImageFromDisk() {
        System.out.println("Loading   " + filename);
    }
 
    public void displayImage() { 
        System.out.println("Displaying " + filename); 
    }
 
}
 
//on System B 
class ProxyImage implements Image {
    private String filename;
    private RealImage image;
 
    public ProxyImage(String filename) { 
        this.filename = filename; 
    }
 
    public void displayImage() {
        if (image == null) {
           image = new RealImage(filename);
        } 
        image.displayImage();
    }
}
 
class ProxyExample  {
    public static void main(String[] args) {
        Image image1 = new ProxyImage("HiRes_10MB_Photo1");
        Image image2 = new ProxyImage("HiRes_10MB_Photo2");     
 
        image1.displayImage(); // loading necessary
        image1.displayImage(); // loading unnecessary
        image2.displayImage(); // loading necessary
        image2.displayImage(); // loading unnecessary
        image1.displayImage(); // loading unnecessary
    }
}
/*
The program''s output is:
Loading   HiRes_10MB_Photo1
Displaying HiRes_10MB_Photo1
Displaying HiRes_10MB_Photo1
Loading   HiRes_10MB_Photo2
Displaying HiRes_10MB_Photo2
Displaying HiRes_10MB_Photo2
*/
Displaying HiRes_10MB_Photo1',1336371541,1336371541,10,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(51,'AMD with RequireJs ','AMD with RequireJs ','// source : https://gist.github.com/907115
//*******************************************
// Level 1, basic API, minimum support
//*******************************************
/*
Modules IDs are strings that follow CommonJS
module names.
*/

//To load code at the top level JS file,
//or inside a module to dynamically fetch
//dependencies, use *require*.
//
//one and two''s module exports are passed as
//function args to the callback.
require([''one'', ''two''], function (one, two) {

});

//Define a module
define([''one'', ''two''], function (one, two) {

    //Return a value to define the module export
    return function () {};
});

//Allow named modules by allowing a string as the
//the first argument (support can be limited
//in Node by only allowing the ID
//to match the expected name by the Node loader)
define(''three'', [''one'', ''two''], function (one, two) {

    //require(''string'') can be used inside function
    //to get the module export of a module that has
    //already been fetched and evaluated.
    var temp = require(''one'');

    //This next line would fail
    var bad = require(''four'');

    //Return a value to define the module export
    return function () {};
});

//''require'', ''exports'' and ''module'' are special dependency
//names that map roughly to the CommonJS values, except this
//require allows the dependency array/callback style mentioned above
define([''require'', ''exports'', ''module''], function (require, exports, module) {

    //exports is particularly (only?) useful for circular
    //dependency cases. If exports is asked for, but there is
    //a return value for this function, favor the return value
    //unless another module has been given this module''s exported
    //value already.
    exports.name = module.id;

    //module is important to get the module ID without
    //knowing the current module ID.
});

//A simple object module with no dependencies
//(very useful for configuration objects):
define({
    color: ''blue'',
    size: ''large''
});

//**********************************************************************
// Level 2, sugar, particularly for converting existing CommonJS modules
//**********************************************************************

//For many dependencies, it may be desirable to list dependencies
//vertically. This form also helps translate old CommonJS modules
//to this wrapped format. It uses Function.prototype.toString() to find
//require(''moduleName'') references and loads them before executing
//the definition function.
define(function (require) {
    //The function arg *must* be called require, and
    //dependencies *must* use that require name in order
    //for the parsing to work.
    var one = require(''one''),
        two = require(''two'');

    //Return can still define a module.
    return {
        color: ''blue''
    };
});

//The above define call can be thought of being converted to
//this form after require calls are parsed out:
define([''require'', ''one'', ''two''], function (require) {});

//For the full access to the CommonJS legacy variables, this form is also supported.
define(function (require, exports, module) {
    var one = require(''one''),
        two = require(''two'');

    //Return can still define a module.
    exports.color = ''blue'';
});

//The above define call can be thought of being converted to
//this form after require calls are parsed out:
define([''require'', ''exports'', ''module'', ''one'', ''two''], function (require, exports, module) {});

/*
NOT ALL CommonJS modules can be converted to this syntax. An important
behavioral difference with this API: all dependencies are loaded *and*
executed before the current module definition function is called. So
in particular, CommonJS code that does these kinds of things will not
work the same, and may even generate an error. 
*/
//BAD
var a;
if (someCondition) {
    a = require(''a1'');
} else {
    a = require(''b1'');
}

//BAD: using a try catch to
//try to load a module that may or
//may not be available then doing something
//with it.
try {
   var a = require(''a'');
   //more stuff here
} catch (e) {
    //a may not exist
}

//Any sort of logic used to choose a module to require needs 
//to be handled by the callback-style require:
require([computedModuleName], function (mod) {});

//Or by using loader plugins, level 3:

//***********************************************
//Level 3, Loader plugins
//***********************************************
/*
Loader plugins allow conditional loading/branching
of loading, and also more complex loading.
Plugins are just regular modules that implement a
load() API. A plugin is indicated by separating
the plugin''s module name from the resource name
by a ! sign.
*/

//This example uses the ''text'' plugin to load a resource
//called some/template.html. So, text.js is loaded, then its
//load() method is called to load some/template.html. The
//load() method is passed a callback function to indicate when
//the resource is loaded.
define([''text!some/template.html''], function (templateString) {
});

/*
Useful plugins:
* env: changes a resource name to include the environment (node or browser)
  in the resource name. I use this in RequireJS to allow running 
  the optimizer either in Node or Rhino:
  https://github.com/jrburke/requirejs/blob/optimizer/build/jslib/env.js
  It can be seen as a replacement of the overlays feature in packages.
* text: to load a text file, useful for templates.
* i18n: can load a few modules to present one object
  to the application which is a combination of country, language.

This plugin approach can be used instead of the require.extensions in Node.
So things like a coffeescript or binary extensions could
be supported via coffee! and node! plugins.

Plugins also can implement some APIs to participate in a build optimizer, 
so they can inject their resources into a built file. This is very useful 
for browsers, but could also benefit node, by allowing single file JS 
utilities instead of delivering a whole package. Complete plugin 
API is here:
http://requirejs.org/docs/plugins.html
*/

//***********************************************
//Level 4, configuration and pathing and packages
//***********************************************
/*
Browsers should only use one path to look up a module. It is error 
prone and very bad for performance to look in more than one place. 
So it is important to configure where the baseUrl for all modules 
are found, and to allow some path mappings for modules that may not
be inside that baseUrl.

I use an object passed to require() in the top level script, but 
I am open to specifying a require.config() instead of overloading 
require() so much:
*/

require({
    baseUrl: ''scripts'',
    //Optional path adjustments for
    //modules that are not in the baseUrl directory.
    paths: {
        ''some/module'': ''../external/some/module''
    }
});

/*
1) CommonJS packages with a ''lib'' and ''main'' config give too many
options for configuration, and in a browser configuration those 
config values need to be passed down to the client. This is 
awkward and ugly. I do support it in RequireJS via package config:
http://requirejs.org/docs/api.html#packages

However, I much rather prefer a stronger convention and 
to remove the ''main'' and ''lib'' features of CommonJS packages. 
In this way, a package manager does not have to parse the 
package.json and insert configuration in the application. 
It is much cleaner and easier to follow.

So I prefer to move to an approach where getting a module from a
package uses its explicit module name. So instead of doing
require(''packageName''), use
require(''packageName/index'') or require(''packageName/main'')
instead. This means there is no configuration besides a baseUrl
is needed, and it is clearer all around what is going on.

2) I have found with other systems like Java and Python that having a 
classpath or a set of commonly used packages that are used across all 
applications to be a source of pain than an actual help. Version 
conflicts being the main issue, and tracking down the magic directories 
used by an execution environment being another.

By requiring each app to have its own packages relative to its own 
baseUrl, it makes the application much more understandable and robust. 
Since there is only one lookup path per module it is even clearer. 

So that is the other change I advocate: no more require.paths, 
no magic place to install modules. Having some basic modules
delivered as part of Node still may make sense though.

This also matches how web browser applications work today -- all
the scripts need to be visible relative to the HTML page on URLs
that are easy to discover.
*/',1336528177,1336528177,2,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(52,'CommonJS wrapper for RequireJS','CommonJS wrapper for RequireJS','/*
A "simplified CommonJS wrapper" form is also supported by many of the AMD loaders, if people want something close to the CommonJS format, and is more lightweight than your third example:
*/

define(function (require) {
    var myLib = require(''path/to/myLib'');
    return moduleValue;
});
If you want to use CommonJS exports and module:

define(function (require, exports, module) {
    var myLib = require(''path/to/myLib'');
    exports.foo = ''foo'';
});
/*
In these forms, the AMD loader will toString the function and scan for the require calls, load and execute those dependencies then call this function. More info here: http://requirejs.org/docs/commonjs.html
*/',1336542733,1336542733,2,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(53,'CurlJS - exemple','CurlJs - simple exemple','<script>

    // configure curl
    curl = {
        paths: {
            cssx: ''cssx/src/cssx/'',
            stuff: ''my/stuff/''
        }
    };

</script>
<script src="../js/curl.js" type="text/javascript"></script>
<script type="text/javascript">

    curl(
        // fetch all of these resources ("dependencies")
        [
            ''stuff/three'', // an AMD module
            ''cssx/css!stuff/base'', // a css file
            ''i18n!stuff/nls/strings'', // a translation file
            ''text!stuff/template.html'', // an html template
            ''domReady!''
        ]
    )
    // when they are loaded
    .then(
        // execute this callback, passing all dependencies as params
        function (three, link, strings, template) {
            var body = document.body;
            if (body) {
                body.appendChild(document.createTextNode(''three == '' + three.toString() + '' ''));
                body.appendChild(document.createElement(''br''));
                body.appendChild(document.createTextNode(strings.hello));
                body.appendChild(document.createElement(''div'')).innerHTML = template;
            }
        },
        // execute this callback if there was a problem
        function (ex) {
            var msg = ''OH SNAP: '' + ex.message;
            alert(msg);
        }
    );

</script>',1336584351,1336584351,2,3,1,0,'FALSE',0);
INSERT INTO "snippets" VALUES(54,'JavaScript Design Patterns: Mediator','JavaScript Design Patterns: Mediator','// source : http://arguments.callee.info/2009/05/18/javascript-design-patterns--mediator/

 Mediator = function() {
        
        var debug = function() {
            // console.log or air.trace as desired
        };
        
        var components = {};
        
        var broadcast = function(event, args, source) {
            var e = event || false;
            var a = args || [];
            if (!e) {
                return;
            }
            //debug(["Mediator received", e, a].join('' ''));
            for (var c in components) {
                if (typeof components[c]["on" + e] == "function") {
                    try {
                        //debug("Mediator calling " + e + " on " + c);
                        var s = source || components[c];
                        components[c]["on" + e].apply(s, a);
                    } catch (err) {
                        debug(["Mediator error.", e, a, s, err].join('' ''));
                    }
                }
            }
        };
        
        var addComponent = function(name, component, replaceDuplicate) {
            if (name in components) {
                if (replaceDuplicate) {
                    removeComponent(name);
                } else {
                    throw new Error(''Mediator name conflict: '' + name);
                }
            }
            components[name] = component;
        };
        
        var removeComponent = function(name) {
            if (name in components) {
                delete components[name];
            }
        };
        
        var getComponent = function(name) {
            return components[name] || false;
        };
        
        var contains = function(name) {
            return (name in components);
        };
        
        return {
            name      : "Mediator",
            broadcast : broadcast,
            add       : addComponent,
            rem       : removeComponent,
            get       : getComponent,
            has       : contains
        };
    }();


/// use :

   Mediator.add(''TestObject'', function() {
        
        var someNumber = 0; // sample variable
        var someString = ''another sample variable'';
        
        return {
            onInitialize: function() {
                // this.name is automatically assigned by the Mediator
                alert(this.name + " initialized.");
            },
            onFakeEvent: function() {
                someNumber++;
                alert("Handled " + someNumber + " times!");
            },
            onSetString: function(str) {
                someString = str;
                alert(''Assigned '' + someString);
            }
        }
    }());
    Mediator.broadcast("Initialize");                 // alerts "TestObject initialized"
    Mediator.broadcast(''FakeEvent'');                  // alerts "Handled 1 times!" (I know, bad grammar)
    Mediator.broadcast(''SetString'', [''test string'']); // alerts "Assigned test string"
    Mediator.broadcast(''FakeEvent'');                  // alerts "Handled 2 times!"
    Mediator.broadcast(''SessionStart'');               // this call is safely ignored
    Mediator.broadcast(''Translate'', [''this is also safely ignored'']);',1336620936,1336620936,2,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(55,'_VIMRC file example','_VIMRC file example','"""""""""""
"BEGIN MES SETTINGS
"""""""""""
set ff=unix
set number
syntax on
set mouse=a
"colo darkblue
colo desert
set noswapfile
"set guifont=Lucida_Console:h9
set guifont=Consolas:h10

set backspace=indent,eol,start
filetype plugin on
filetype on
set nowrap
"utilise tab pour l''auto completion
"inoremap <tab> <c-x><c-o>
"USE CTRL SPACE FOR INDENT / UTILISER CTRL SPACE pour indentation
inoremap <c-space> <c-x><c-o>
"filetype indentation

set smartindent
set autoindent
set expandtab
set softtabstop=2
set shiftwidth=2
filetype indent on
"raccourci zen coding
let g:user_zen_expandabbr_key = ''<c-e>''
"""d''autres options pour l''auto completion
set wildmode=list,full
set wildmenu
"""auto close quotes
inoremap " ""<left>
inoremap "<space> "
inoremap "" ""
inoremap ''<space> ''
inoremap '' ''''<left>
inoremap '''' ''''
"""AUTO CLOSE BRACKETS
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {<space> {
inoremap {}     {}
"AUTO CLOSE PARANTHESIS
inoremap (      ()<Left>
inoremap (<space> (
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()
"""AUTO CLOSE ARRAY PARANTHESIS
inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O
inoremap [[     [
inoremap [<space> [
inoremap []     []
"save shortcut"
inoremap <c-s> <esc>:w<cr>i
map <c-s> <esc>:w<cr>i
map <f5> <esc>:NERDTreeToggle<cr>
inoremap <f5> <esc>:NERDTreeToggle<cr>

"INDENT GUIDES
IndentGuidesEnable

"TlistToggle
inoremap <f8> <esc>:TlistToggle<cr>
map <f8> <esc>:TlistToggle<cr>

if executable(''coffeetags'')
  let g:tagbar_type_coffee = {
        \ ''ctagsbin'' : ''coffeetags'',
        \ ''ctagsargs'' : ''-f coffeetags'',
        \ ''kinds'' : [
        \ ''f:functions'',
        \ ''o:object'',
        \ ],
        \ ''sro'' : ".",
        \ ''kind2scope'' : {
        \ ''f'' : ''object'',
        \ ''o'' : ''object'',
        \ }
        \ }
endif

set fdm=indent
set foldcolumn=4',1336634930,1336634930,11,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(56,'GIT - Rename a branch','GIT - Rename a branch','git branch -m old_branch new_branch',1336665430,1336665430,11,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(57,'Parse an XML Document','Parse an XML Document','/*
source : http://www.w3schools.com/xml/xml_parser.asp
Parse an XML Document
The following code fragment parses an XML document into an XML DOM object:
*/

if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.open("GET","books.xml",false);
xmlhttp.send();
xmlDoc=xmlhttp.responseXML;
/*
Parse an XML String

The following code fragment parses an XML string into an XML DOM object:
*/
txt="<bookstore><book>";
txt=txt+"<title>Everyday Italian</title>";
txt=txt+"<author>Giada De Laurentiis</author>";
txt=txt+"<year>2005</year>";
txt=txt+"</book></bookstore>";

if (window.DOMParser)
  {
  parser=new DOMParser();
  xmlDoc=parser.parseFromString(txt,"text/xml");
  }
else // Internet Explorer
  {
  xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
  xmlDoc.async=false;
  xmlDoc.loadXML(txt); 
  }',1336670453,1336670453,2,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(58,'Git - Change commit encoding to UTF8','Git - Change commit encoding to UTF8','git config --global i18n.commitEncoding ''utf8''',1336777244,1336777244,11,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(59,'Custom DOM events','Custom DOM events','//Listen for the event
window.addEventListener("MyEventType", function(evt) {
    alert(evt.detail);
}, false);

//Dispatch an event
var evt = document.createEvent("CustomEvent");
evt.initCustomEvent("MyEventType", true, true, "Any Object Here");
window.dispatchEvent(evt);
link|edit|flag',1336831975,1336831975,2,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(60,'a new snippet','description of a new snippet','content of the new snippet',1336924978,1336924978,1,3,NULL,0,'FALSE',0);
INSERT INTO "snippets" VALUES(61,'Coffeescript tips and tricks','Coffeescript tips and tricks','# source : https://gist.github.com/993584

# These are my notes from the PragProg book on CoffeeScript of things that either 
# aren''t in the main CS language reference or I didn''t pick them up there. I wrote 
# them down before I forgot, and put it here for others but mainly as a reference for 
# myself.

# assign arguments in constructor to properties of the same name:
class Thingie
    constructor: (@name, @url) ->

# is the same as:
class Thingie
    constructor: (name, url) ->
        @name = name
        @url = url

#execute a function with no arguments:
lcword = do str.toLowerCase
# is the same as:
lcword = str.toLowerCase()

# invoke a method on each object in an array
(marker.remove()) for marker in @markers

for key, value of object
     # do things with key and value

for own key, value of object
     # do things with object''s own properties only

for key, value of object when key in [''foo'', ''bar'', ''baz'']
     # iterate through properties that meet the when condition

# give me an array''s values based on a condition: 
foobar = (value for key, value of object when key in [''foo'', ''bar''])

for x in [1..100] by 10
     # iterate from 1 to 100 in steps of 10

# Call the "process" function on each property of results array that has "food" in the title
process result for result in results when _.include(result.title, ''food'')

# Executing an anonymous function while a condition is met:
a = 0
(do -> console.log(a++)) while a<10
(do -> console.log(a--)) until a is 1

# Put the comprehension in parentheses to return it as an array, including only those values that meet the by/when condition:
evens = (x for x in [2..10] by 2)
=> evens = [2,4,6,8,10]

# Given an alphabet:
alphabet = ''abcdefghijklmnopqrstuvwxyz''

# Iterate over part of the alphabet:
console.log letter for letter in alphabet[4..8]
=> Logs ''e'' through ''i'' to the console

# Iterate through the first part of the alphabet, up to e:
console.log letter for letter in alphabet[..4]

# Stop just before e (notice the 3 dots in the range:
console.log letter for letter in alphabet[...4]

# Start at e and go to the end alphabet:
console.log letter for letter in alphabet[4..]

# Useful for pagination:
paginate = (start, end) -> @results[start..end]

# Just JS but useful to remember:
break # stop iterating
continue # jump to the next iteration

# Iterate using "for" but have each iteration run in closure:
for x in arr
     do (x) ->
          # do something in own scope',1337017811,1337017811,14,2,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(62,'Couchapp - 101','how to create a basic couch app','// install couch db
// install couch app tool
in the console :
couchapp generate hello-couch',1337194870,1337194870,2,2,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(63,'REST requests with Curl','REST requests with Curl','source : http://blogs.plexibus.com/2009/01/15/rest-esting-with-curl/

REST-esting with cURL
I have been working on RESTful web applications over the past few months and have been using cURL to quickly test functionality.

The following are basic curl commands to test REST resources

POSTing data to a REST resource:

curl -i -H "Accept: application/json" -X POST -d "firstName=james" http://192.168.0.165/persons/person
where,
i – show response headers
H – pass request headers to the resource
X – pass a HTTP method name
d – pass in parameters enclosed in quotes; multiple parameters are separated by ‘&’
The above command posts the first name “james” to the persons resource. Assuming the server creates a new person resource with first name of James, I also tell the server to return a json representation of the newly created resource.

PUT a resource:

curl -i -H "Accept: application/json" -X PUT -d "phone=1-800-999-9999" http://192.168.0.165/persons/person/1
This puts a phone number to the person resource created in the previous example.

GET a resource:

curl -i -H "Accept: application/json" http://192.168.0.165/persons/person/1
For GET requests, the -X GET option is optional.

curl -i -H "Accept: application/json" http://192.168.0.165/persons?zipcode=93031
You can pass in query parameters by appending it to the url.

curl -i -H "Accept: application/json" "http://192.168.0.165/persons?firstName=james&lastName=wallis"
The resource uri needs to be quoted if you pass in multiple query parameters separated by ‘&’. If you have spaces in the query values, you should encode them i.e. either use the ‘+’ symbol or %20 instead of the space.

DELETE a resource:

curl -i -H "Accept: application/json" -X DELETE http://192.168.0.165/persons/person/1
To delete a resource, supply DELETE as a -X option.

Using POST to PUT a resource:

curl -i -H "Accept: application/json" -H "X-HTTP-Method-Override: PUT" -X POST -d "phone=1-800-999-9999" http://192.168.0.165/persons/person/1
Some clients do not support PUT or it’s difficult to send in a PUT request. For these cases, you could POST the request with a request header of X-HTTP-Method-Override set to PUT. What this tells the server is that the intended request is a PUT.
Most web servers (or you could code it) support the X-HTTP-Method-Override and convert the request method to the intended HTTP method (value of the X-HTTP-Method-Override)
This example puts a phone number (by POSTing) to the person resource identified by 1.

Using POST to DELETE a resource:

curl -i -H "Accept: application/json" -H "X-HTTP-Method-Override: DELETE" -X POST http://192.168.0.3:8090/persons/person/1
Similar to the previous command, this example deletes the person resource identified by the above uri using the POST HTTP method but telling the server to override it with DELETE.

Another good tool to test REST resources is the Poster Firefox Add-on. It’s a great GUI tool if you do not want to get down and dirty with cURL or if you are testing from Windows (of course you could install Cygwin and then install and use cURL).
But I’m still more productive with cURL as opposed to Poster.

To use cURL to PUT/GET files, see here.',1337197717,1337197717,11,2,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(64,'a new snippet','description of a new snippet','content of the new snippet',1337231667,1337231667,1,3,NULL,0,'FALSE',0);
INSERT INTO "snippets" VALUES(65,'Shortcut  icon - favicon','Shortcut  icon - favicon','<!-- in the HEAD of a html document -->
<link rel="shortcut icon" type="image/png" href="images/mp.png" />
',1337231710,1337231710,4,2,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(66,'CouchDB 101','CouchDB 101','#lister les bases de données

curl -X GET http://127.0.0.1:5984/_all_dbs

# creer une base de donnée

curl -X PUT http://127.0.0.1:5984/database_name

# effacer une base de donnée

curl -X DELETE http://127.0.0.1:5984/database_name',1337303834,1337303834,11,2,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(67,'REST-esting with cURL: File Handling','REST-esting with cURL: File Handling','#REST-esting with cURL: File Handling
#The preview of CloudIQ Storage brings Amazon S3-like functionality to Managed Service Providers, organizations, and businesses. It opens up new possibilities with distributed, reliable storage of data and and importantly, computational storage.
#
#CloudIQ Storage exposes a RESTful interface that clients can use to store and retrieve files. Using cURL you can be on your way to PUTing and GETing files to CloudIQ Storage or any RESTful server that accepts files. This post is a follow-up to the REST-esting with cURL.
#
#The following are basic curl commands to test PUT/GET of files
#
#PUT a file
#
#view plaincopy to clipboardprint?
curl -i -u fabric-admin:fabric-admin -X PUT -T "test" http://192.168.0.165:16088/files/test  
#where,
#i – show response headers
#u – server authentication information, in the form of user:password
#X – pass a HTTP method name
#T – name of file to upload
#The above command PUTs test file.
#
#Optionally, you can leave out the file part in the URL, ending the URL with a trailing slash. cURL will append the local file name in this case. Note that you must use a trailing slash (/) on the last directory to tell cURL to use the file name as specified in the -T argument or cURL will use your last directory name as the remote file name to use.
#
#view plaincopy to clipboardprint?
curl -i -u fabric-admin:fabric-admin -X PUT -T "test" http://192.168.0.165:16088/files/  
#The above command transfers test file to http://192.168.0.165:16088/files/.
#
#PUT multiple files in single command
#
#You can PUT multiple files via a single command by enclosing them within braces as shown below:
#
#view plaincopy to clipboardprint?
curl -i -u fabric-admin:fabric-admin -X PUT -T "{test4,test5}" http://192.168.0.165:16088/files/  
#The above command transfers files test4 and test5 to http://192.168.0.165:16088/files/.
#
#If you have many files with the almost the same name but differentiated from each other by a number (say, test4, test5, test6, test7), you could use an alternative to the above command to transfer all these files in one cURL command:
#
#view plaincopy to clipboardprint?
curl -i -u fabric-admin:fabric-admin -X PUT -T "test[4-6]" http://192.168.0.165:16088/files/  
#GET a file
#
#view plaincopy to clipboardprint?
curl -u fabric-admin:fabric-admin -O http://192.168.0.165:16088/files/test4  
#where,
#O – use the remote file name for the local file
#The above command GETs the contents of file test4 from remote location http://192.168.0.165:16088/files/test4 and writes the output to local file named like the remote file (in this case, test4).
#
#If you want to store the contents in a local file with a name different from the remote file name, you could use the -o option:
#
#view plaincopy to clipboardprint?
curl -u fabric-admin:fabric-admin -o test10 http://192.168.0.165:16088/files/test4  
#The above command GETs the contents of file test4 from remote location http://192.168.0.165:16088/files/test4 and writes the output to local file test10.
#
#Get HEADers
#There are times when you just need the headers for a file. You could retrieve the headers for a file by running the following command:
#
#view plaincopy to clipboardprint?
curl -I -u fabric-admin:fabric-admin http://192.168.0.165:16088/files/test4  
#where,
#I – fetches the HTTP headers only
#The above command will display the HTTP headers returned by http://192.168.0.165:16088/files/test4
#
#If you want to capture the file contents and the HTTP headers at the same time, you can use the -D option:
#
#view plaincopy to clipboardprint?
curl -u fabric-admin:fabric-admin -D "test4-headers" -O http://192.168.0.165:16088/files/test4  
#The above command GETs the contents of file test4 from remote location http://192.168.0.165:16088/files/test4 and at the same time outputs the HTTP headers to file test4-headers
#
#For more examples using cURL for testing web services, see here.',1337353380,1337353380,11,3,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(68,'Autoload Classes using namespaces ','Autoload Classes using namespaces ','#I think there shouldn''t be tests in an autoload callback function, this callback will trigger 
#because the class you''re trying to load is not defined... in any case if your class is not 
#defined, the code must fail. Therefore an autoload function should be like : 

<?php 
spl_autoload_register(function($className) 
{ 
    require(str_replace(''\\'', ''/'', ltrim($className, ''\\'')) . ''.php''); 
}); 
?> 

#As the "require" function uses the include_path, the folders for the autoinclusion should be added using set_include_path, let''s say your index.php is located in a "public" directory and your MVC classes are in "core", the index.php should be : 

<?php 
define(''ROOT_DIR'', realpath(__DIR__ . ''/..'')); 

set_include_path(ROOT_DIR . PATH_SEPARATOR . get_include_path()); 
?> 

#And of course you want to catch the loading errors, so you can use class_exists : 

<?php 
$className = ''\core\Controller\Hello\World''; 

if (!class_exists($className)) 
{ 
    throw new ErrorException(''Class Not Found !''); 
} 
else 
{ 
    $object = new $className(); 
} 
?> 

#This code sample will autoload the "World.php" file located in your "core/Controller/Hello" directory, assuming that your class declaration is like : 

<?php 
namespace coreControllerHello; 

class World 
{ 
    function __construct() 
    { 
        echo "Helloworld"; 
    } 
} 
?>',1337796731,1337796731,1,2,0,0,'FALSE',0);
INSERT INTO "snippets" VALUES(69,'PDO 101','PDO 101','# What is PDO.
# 
# PDO is a PHP extension to formalise PHP''s database connections by creating a uniform interface. This allows developers to create code which is portable across many databases and platforms. PDO is _not_ just another abstraction layer like PearDB although PearDB may use PDO as a backend. Those of you familiar with Perls DBI may find the syntax disturbingly familiar.
# Note: Your must read the section on Error Handling to benifit from this tutorial
# 
# During this tutorial we will be using a database called animals, which, as you might have guessed, is a database of animals, genius! The animals table is described here.
# CREATE TABLE animals ( animal_id MEDIUMINT(8) NOT NULL AUTO_INCREMENT PRIMARY KEY,
# animal_type VARCHAR(25) NOT NULL,
# animal_name VARCHAR(25) NOT NULL 
# ) ENGINE = MYISAM ;
# 
# INSERT INTO `animals` (`animal_id`, `animal_type`, `animal_name`) VALUES
# (1, ''kookaburra'', ''bruce''),
# (2, ''emu'', ''bruce''),
# (3, ''goanna'', ''bruce''),
# (4, ''dingo'', ''bruce''),
# (5, ''kangaroo'', ''bruce''),
# (6, ''wallaby'', ''bruce''),
# (7, ''wombat'', ''bruce''),
# (8, ''koala'', ''bruce'');
# What databases does PDO support?
# 
# PDO supports many of the popular databases as seen on the list below.
# DBLIB: FreeTDS / Microsoft SQL Server / Sybase
# Firebird (http://firebird.sourceforge.net/): Firebird/Interbase 6
# IBM (IBM DB2)
# INFORMIX - IBM Informix Dynamic Server
# MYSQL (http://www.mysql.com/): MySQL 3.x/4.0
# OCI (http://www.oracle.com): Oracle Call Interface
# ODBC: ODBC v3 (IBM DB2 and unixODBC)
# PGSQL (http://www.postgresql.org/): PostgreSQL
# SQLITE (http://sqlite.org/): SQLite 3.x
# To see if the PDO driver is available for your database, check phpinfo() and you should have a section named PDO and another pdo_mysql or pdo_sqlite depending on your choice of database. You may also check the available drivers with the static method PDO::getAvailableDrivers().
# 
<?php
foreach(PDO::getAvailableDrivers() as $driver)
    {
    echo $driver.''<br />'';
    }
?>
# To enable PDO simply configure --enable-pdo and --with-pdo_sqlite --with_pdo_mysql or whatever database needs supporting by PDO.
# Windows users will need to un-comment the appropriate line in php.ini and restart the web server.
# Where do I begin?
# 
# If you are reading this you are more than likely to have connected to a database using PHP before using a database specific function such as mysql_connect() or pg_connect or, for the truely evolved coder, SQLite. To use PDO with your database you need to have the correct PDO driver installed for it. For the SQLite PDO driver you need to configure PHP --with-pdo-sqlite. If you are using a RPM based system there are pdo-sqlite.rpm''s available. Before we go any further, lets connect to a database and see what all the fuss is about.
# Connect to a database
# 
# Every interaction with a database begins with a connection. Regardless of the database you use, you must connect first and establish a database handler. After connecting you your database of choice, much of the PDO methods are similar. This is why PDO is such a powerful and useful tool for PHP. Here we show how to connect to various databases and establish a database handler object that we can use for further interaction with the database.
# Connect with PgSQL

# As mentioned above, you may have previously tried to connect to a PgSQL database using pg_connect. Here we connect with PDO.
<?php
try {
    $db = new PDO("pgsql:dbname=pdo;host=localhost", "username", "password" );
    echo "PDO connection object created";
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# So that was a bit of a no-brainer to start with, we see the use of "new" to create the PDO object followed by the database type username and password. This should be familiar to most people who have connected to a database before using traditional methods.. As we have used try{} and catch(){} we see upon failure that an exception is thrown with the error message "could not find driver". This tells us the PDO_PGSQL driver is not present and needs to be loaded. As noted, an exception is thrown. PDO can handle errors in several ways, more on this later.
# How did it connect to the database?
# The database connection is handled internally by PDO''s __construct() and this represents our database connection.
# Lets see what happens if we try to connect to database as we did above without catching the exception and see what happens..
<?php
 $db = new PDO("pgsql:dbname=no_database;host=localhost", "username", "password" );
?>
# From the above snippet you will get a result something like this below
# Fatal error: Uncaught exception ''PDOException'' with message ''could not find driver'' in /www/pdo.php:2 Stack trace: #0 /www/pdo.php(2): PDO->__construct(''pgsql:dbname=pd...'', ''username'', ''password'') #1 {main} thrown in /www/pdo.php on line 2
# This is the default behaviour when an exception is not caught, a backtrace is generated and the script is terminated. As you can see, all the information is dumped including the file path and the database username and password. It is the responsibility of the coder to catch exceptions or to deal with the errors using set_exception_handler() function to prevent this happening. More about handling errors and exceptions later.
# Connect to SQLite
# When PDO is used with SQLite, database creation becomes even easier. Simply specify the path to the database file and it will be loaded. If the database file does not exist, PDO will attempt to create it. Lets see how we go with the same code but change the database to SQLite.
<?php
try {
    /*** connect to SQLite database ***/
    $dbh = new PDO("sqlite:/path/to/database.sdb");
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# Because the database path does not exist and cannot be created, an exception is thrown, the exception is caught in the catch block and the error message is displayed with $e->Message(). Now that we know how to create a database, we can create tables and INSERT some data.
# Another feature of SQLite is the ability to create tables in memory. This can be amazingly helpful if you wish to create tempory databases or tables or even for development code.
<?php
try {
    /*** connect to SQLite database ***/
    $db = new PDO("sqlite::memory");

    /*** a little message to say we did it ***/
    echo ''database created in memory'';
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# We see above that a database is created in memory and a message is displayed to let us know. If the creation of the database failed, a PDO exception would be thrown and the script terminated at that point, passing control to the catch block.
# Connect to MySQL
# 
# MySQL is the choice of many web developers and will be used as the database of choice for much of this tutorial. Here we see how to connect to a MySQL database.

<?php

/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=mysql", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database'';
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# Connect to Firebird
# Often used by developers using windows, Firebird is a good database and connection is just as simple as the examples above.
<?php
try {
    $dbh = new PDO("firebird:dbname=localhost:C:\Programs\Firebird\DATABASE.FDB", "SYSDBA", "masterkey");
    }   
catch (PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# Connect to Informix
#Informix is popular with many windows users also, this example shows how to connect to an informix database cataloged as InformixDB in odbc.ini:
<?php
try {
    $dbh = new PDO("informix:DSN=InformixDB", "username", "password");
    }
catch (PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# Connect to Oracle

# The Oracle database is used by many ''enterprise'' companies but these days there are sleeker options. Lets see a simple connection to Oracle
<?php
try {
    $dbh = new PDO("OCI:", "username", "password")
    }
catch (PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# This works fine for a simple Oracle connection. The oracle driver may take two optional parameters, The database name, and the character set. To connect with a database name of "accounts" and a charset of UTF-8 the following code should be used.
<?php
try {
    $dbh = new PDO("OCI:dbname=accounts;charset=UTF-8", "username", "password");
    }
catch (PDOException $e)
    {     echo $e->getMessage();     } ?>
# Connect to ODBC

# There are many connections ODBC can create, here we show how to connect to a MS Access database named accounts. The specified path is c:\\accounts.mdb.
<?php
try {
    $dbh = new PDO("odbc:Driver={Microsoft Access Driver (*.mdb)};Dbq=C:\accounts.mdb;Uid=Admin");
    }
catch (PDOException $e)
    {
    echo $e->getMessage();
    } 
?>
# Connect to DBLIB

# Once again a Windows specific database, DBLIB can be used as follows
<?php
try {
    $hostname = "localhost";
    $port     = 10060;
    $dbname   = "my_database";
    $username = "username";
    $password = "password";

    $dbh = new PDO ("dblib:host=$hostname:$port;dbname=$dbname","$username","$password");
    }
catch (PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# Connect to IBM

# This example shows connecting to an IBM DB2 database named accounts
<?php
try {
    $db = new PDO("ibm:DRIVER={IBM DB2 ODBC DRIVER};DATABASE=accounts; HOSTNAME=1.2.3,4;PORT=56789;PROTOCOL=TCPIP;", "username", "password");
    }
catch (PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# Close a Database Connection

# Up to this point we have seen how to connect to a database using PDO. But of course, we also need to disconnect when we have finished. To close the connection the object needs to be destroyed so that no reference to it remains. This is normally done at the end of a script where PHP will automatically close the connection. However, the connection may be close implicitly by assigning the value of null to the object as seen below.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=mysql", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database'';

    /*** close the database connection ***/
    $dbh = null;
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# If the database connection fails, the code to assign a null value is never called as the exception throws control to the catch block.
# PDO Query

# Now that we can open and close a connection to the database with PDO, we can make use of it for what databases are made for, storing and retrieving information. The simplest form of query is the PDO query method. As the name suggests, this is used to perform database queries. Before we begin to query a database, lets create a small database with a table for animals. This will be a MySQL database for use throughout much of this tutorial. Remember, because PDO provides a common set of tools for databases, once we have the correct connection, the rest of the code is the same, regardless of the database you choose. When using PDO to query a database, the function used to do so depends on the statement you wish to send to the database. Below we will see three queries on how to INSERT, SELECT and UPDATE.
# INSERT

To gather information from a database, we first need to put some info into it. We use the same code from above to connect and disconnect from the database and the INSERT query is accomplished using the PDO::exec method.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** INSERT data ***/
    $count = $dbh->exec("INSERT INTO animals(animal_type, animal_name) VALUES (''kiwi'', ''troy'')");

    /*** echo the number of affected rows ***/
    echo $count;

    /*** close the database connection ***/
    $dbh = null;
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
The output of the script above will look like this:
Connected to database
1
This shows us that we connected successfully to the database and then we have displayed the number of affected rows. PDO::exec returns the number of affected rows if successful, or zero (0) if no rows are affected. This may cause issues if you are checking for a boolean value and why it is recommended using === when to check for type also, as zero (0) may evaluate to boolean FALSE.
The PDO::exec method should be used for SQL statements that do not return a result set. We could use this same method to INSERT many more animals to our database, but a more effecient method would be to use a transaction. This is covered in the section on Transactions.
SELECT

Unlike PDO::exec the PDO::query method returns a result set, that is, a group of information from the database in the form of a PDOStatement object. Our database should look a little like the example in the What is PDO section. Using this we can SELECT information.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement ***/
    $sql = "SELECT * FROM animals";
    foreach ($dbh->query($sql) as $row)
        {
        print $row[''animal_type''] .'' - ''. $row[''animal_name''] . ''<br />'';
        }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
From the script above, we can expect the results to look like this:
Connected to database
emu - bruce
funnel web - bruce
lizard - bruce
dingo - bruce
kangaroo - bruce
wallaby - bruce
wombat - bruce
koala - bruce
kiwi - troy
You will have noticed that we can iterate over the result set directly with foreach. This is because internally the PDO statement implements the SPL traversble iterator, thus giving all the benifits of using SPL. For more on SPL refer to the Introduction to SPL page. The greatest benifit of this is that SPL iterators know only one element at a time and thus large result sets become manageable without hogging memory.
UPDATE

To update a field in a database with PDO we once again use the PDO::exec method in the same manner as we did with the INSERT
<?php

/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** INSERT data ***/
    $count = $dbh->exec("UPDATE animals SET animal_name=''bruce'' WHERE animal_name=''troy''");

    /*** echo the number of affected rows ***/
    echo $count;

    /*** close the database connection ***/
    $dbh = null;
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
Once again we see that the connection is made to the database and one row is affected as now the kiwi has become a true Australian like the rest of the creatures. PDO::exec should be used for all database queries where no result set is required.
FETCH Modes

The section above showed how using PDO::query we can fetch information from the database. The PDO::query method returns a PDOStatement object that can be utilized in much the same was as mysql_fetch_object() or pg_fetch_object(). Of course there are times when an numerical index is needed or an associative index. PDO::query provides for this also by allowing the coder to set the fetch mode for via the PDOStatement object or via PDOStatement::setFetchMode().
FETCH ASSOC

To fetch an associative array from our results the constant PDO::FETCH_ASSOC is used and returns the column names as indexes or keys of the resulting array.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement ***/
    $sql = "SELECT * FROM animals";

    /*** fetch into an PDOStatement object ***/
    $stmt = $dbh->query($sql);

    /*** echo number of columns ***/
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    /*** loop over the object directly ***/
    foreach($result as $key=>$val)
    {
    echo $key.'' - ''.$val.''<br />'';
    }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
The above code will give a result like this:
Connected to database
animal_id - 1
animal_type - emu
animal_name - bruce
PDO has returned the results as a PDOStatement object that we can iterate over directly. The resulting indexes are the names of the fields within the animals database.
FETCH NUM

Like PDO::FETCH_ASSOC, the PDO::FETCH_NUM produces a numerical index of the result set rather than the field names.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement ***/
    $sql = "SELECT * FROM animals";

    /*** fetch into an PDOStatement object ***/
    $stmt = $dbh->query($sql);

    /*** echo number of columns ***/
    $result = $stmt->fetch(PDO::FETCH_NUM);

    /*** loop over the object directly ***/
    foreach($result as $key=>$val)
    {
    echo $key.'' - ''.$val.''<br />'';
    }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
The above code will give a result like this:
Connected to database
0 - 1
1 - emu
2 - bruce
As you can see above the indexes are now numeric in the result set
FETCH BOTH

There may be times you need to fetch both numerical and associative indexes. PDO::FETCH_BOTH produces a numerical and associative index of the result set so you can use either, or both.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement ***/
    $sql = "SELECT * FROM animals";

    /*** fetch into an PDOStatement object ***/
    $stmt = $dbh->query($sql);

    /*** echo number of columns ***/
    $result = $stmt->fetch(PDO::FETCH_BOTH);

    /*** loop over the object directly ***/
    foreach($result as $key=>$val)
    {
    echo $key.'' - ''.$val.''<br />'';
    }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
Now we see the results have included both indexes.
Connected to database
animal_id - 1
0 - 1
animal_type - emu
1 - emu
animal_name - bruce
2 - bruce
FETCH OBJECT

This little gem takes the result set and returns it as an anonymous object or stdClass and maps the field names from the database as object properties with the values the values of stored in the database.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement ***/
    $sql = "SELECT * FROM animals";

    /*** fetch into an PDOStatement object ***/
    $stmt = $dbh->query($sql);

    /*** echo number of columns ***/
    $obj = $stmt->fetch(PDO::FETCH_OBJ);

    /*** loop over the object directly ***/
    echo $obj->animal_id.''<br />'';
    echo $obj->animal_type.''<br />'';
    echo $obj->animal_name;

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
The above code gives the results like this:
Connected to database
1
emu
bruce
The use of the field names as class properties makes integrating results into an Object Oriented envioronment simple.
FETCH LAZY

PDO::FETCH_LAZY is odd as it combines PDO::FETCH_BOTH and PDO::FETCH_OBJ. I am unsure why you would want to do this, but it must have been important enough for somebody to create it. The code below is that of PDO::FETCH_BOTH and is reproduced here for examples sake.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement ***/
    $sql = "SELECT * FROM animals";

    /*** fetch into an PDOStatement object ***/
    $stmt = $dbh->query($sql);

    /*** echo number of columns ***/
    $result = $stmt->fetch(PDO::FETCH_BOTH);

    /*** loop over the object directly ***/
    foreach($result as $key=>$val)
    {
    echo $key.'' - ''.$val.''<br />'';
    }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
The above code will give a result the same as that of PDO::FETCH_BOTH. Genius!
FETCH CLASS

PDO::FETCH_CLASS instantiates a new instance of the specified class. The field names are mapped to properties (variables) within the class called. This saves quite a bit of code and speed is enhanced as the mappings are dealt with internally.
<?php
class animals{

public $animal_id;

public $animal_type;

public $animal_name;

/***
 *
 * @capitalize first words
 *
 * @access public
 *
 * @return string
 *
 */
public function capitalizeType(){
 return ucwords($this->animal_type);
}

} /*** end of class ***/

/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement ***/
    $sql = "SELECT * FROM animals";

    /*** fetch into an PDOStatement object ***/
    $stmt = $dbh->query($sql);

    /*** fetch into the animals class ***/
    $obj = $stmt->fetchALL(PDO::FETCH_CLASS, ''animals'');

    /*** loop of the object directly ***/
    foreach($obj as $animals)
        {
        /*** call the capitalizeType method ***/
        echo $animals->capitalizeType().''<br />'';
        } 
    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
The code above produces a list of animal types, with the first letter capitalized like this:
Connected to database
Emu
Funnel Web
Lizard
Dingo
Kangaroo
Wallaby
Wombat
Koala
Kiwi
The PDO::FETCH_CLASS constant has fetched the results directly into the animals class where we were able to directly manipulate the results, nifty.
PDO provides an alternative to PDO::fetch and PDO::FETCH_CLASS. PDOStatement::fetchObject() will bundle them together to give the same result as shown here.
<?php
class animals{

public $animal_id;

public $animal_type;

public $animal_name;

/***
 *
 * @capitalize first words
 *
 * @access public
 *
 * @return string
 *
 */
public function capitalizeType(){
 return ucwords($this->animal_type);
}

} /*** end of class ***/

/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement ***/
    $sql = "SELECT * FROM animals";

    /*** fetch into an PDOStatement object ***/
    $stmt = $dbh->query($sql);

    /*** fetch into the animals class ***/
    $animals = $stmt->fetchObject(''animals'');

    /*** echo the class properties ***/
    echo $animals->animal_id.''<br />'';
    echo $animals->capitalizeType().''<br />'';
    echo $animals->animal_name;

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
The above code gives the results like this:
Connected to database
1
Emu
bruce
Note that we have called the animals::capitalizeType() method to show that we are in fact working with an instance of the animals class. PDO::fetchObject() will also work as a substitute for PDO::FETCH_OBJ.
FETCH INTO

The PDO::FETCH_INTO constant allows us to fetch the data into an existing instance of a class. Like PDO::FETCH_CLASS the field names are mapped to the class properties. With this in mind, we should be able to replicate the behaviour of PDO::FETCH_CLASS by instantiating the new object when setting the fetch mode. In this instance, the fetch mode is set using PDO::setFetchMode() method.
<?php
class animals{

public $animal_id;

public $animal_type;

public $animal_name;


public function capitalizeType(){
 return ucwords($this->animal_type);
}

} /*** end of class ***/

/*** instantiate a new animals instance ***/
$animals = new animals;

$animals->animal_id = 10;

$animals->animal_type = ''crocodile'';

$animals->animal_name = ''bruce'';

/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement ***/
    $sql = "SELECT * FROM animals";

    /*** fetch into an PDOStatement object ***/
    $stmt = $dbh->query($sql);

    /*** set the fetch mode with PDO::setFetchMode() ***/
    $stmt->setFetchMode(PDO::FETCH_INTO, new animals);

    /*** loop over the PDOStatement directly ***/
    foreach($stmt as $animals)
    {
    echo $animals->capitalizeType().''<br />'';
    } 
    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
Once again, the above code produces a list of animal types, with the first letter capitalized like this:
Connected to database
Emu
Funnel Web
Lizard
Dingo
Kangaroo
Wallaby
Wombat
Koala
Kiwi
Error Handling

PDO error handling is comes in several flavours. Previously in this tutorial we have have only used the simplest of try{} catch(){} blocks to catch an error in the database connection, but what of other errors? perhaps a field name does not exist? Lets see how we go with a simple error with the previous code.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** The SQL SELECT statement with incorrect fieldname ***/
    $sql = "SELECT username FROM animals";

    foreach ($dbh->query($sql) as $row)
        {
        print $row[''animal_type''] .'' - ''. $row[''animal_name''] . ''<br />'';
        }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
The above script will produce an error such as this:
Connected to database

Warning: Invalid argument supplied for foreach() in /www/pdo.php on line 18
This is because there is no error handling. The SELECT statement has a field name ''username'' which does not exist and an error is generated by the database. The only default error handling is done with the initial connection. Unless we deal with the error, we have a problem with displaying full path to the world. To deal with this we need to set an attribute to the type of error handling we wish to utilize. The types of error handling are
Exception
Warning
Silent
Lets begin with exception as we have the try{} catch(){} blocks in place already.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** set the error reporting attribute ***/
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    /*** The SQL SELECT statement ***/
    $sql = "SELECT username FROM animals";
    foreach ($dbh->query($sql) as $row)
        {
        print $row[''animal_type''] .'' - ''. $row[''animal_name''] . ''<br />'';
        }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
Now with the error mode set to Exception the error generated looks like this:
Connected to database
SQLSTATE[42S22]: Column not found: 1054 Unknown column ''username'' in ''field list''
Normally we would not show this type of error to the end user, and the exception would be handled perhaps with message saying No Results Found or something vague, but this does show how we can set the error mode as we wish. To set the error mode to Warning should look easy from here.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** set the error reporting attribute ***/
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING);

    /*** The SQL SELECT statement ***/
    $sql = "SELECT username FROM animals";
    foreach ($dbh->query($sql) as $row)
        {
        print $row[''animal_type''] .'' - ''. $row[''animal_name''] . ''<br />'';
        }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
Now a different error is displayed.
Connected to database

Warning: PDO::query() [function.PDO-query]: SQLSTATE[42S22]: Column not found: 1054 Unknown column ''username'' in ''field list'' in /www/pdo.php on line 21

Warning: Invalid argument supplied for foreach() in /www/pdo.php on line 21
Here and E_WARNING has been generated and if display_errors is on the error would be seen by an end user. It is hoped that if you are in a production environment this is not the case.
Lastly, there is the Silent mode. As the name suggests, this mode silences the errors so no output is sent from the error. However, it does not stop the code at the point of error and any further errors are still sent.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** set the error reporting attribute ***/
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_SILENT);

    /*** The SQL SELECT statement ***/
    $sql = "SELECT username FROM animals";
    foreach ($dbh->query($sql) as $row)
        {
        print $row[''animal_type''] .'' - ''. $row[''animal_name''] . ''<br />'';
        }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
Now we see the script above produces the following output.
Connected to database

Warning: Invalid argument supplied for foreach() in /www/pdo.php on line 21
As you can see, the error has been silenced, but the following error has not been attended to, and would need further checks to ensure the value passed to the foreach is a valid arguement.
As we saw with the exception code, the SQLSTATE code was part of the error message. This error code is also available with the PDO::errorCode() method.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }

/*** an invalide fieldname ***/
$sql = "SELECT username FROM animals";

/*** run the query ***/
$result = $dbh->query($sql);

/*** show the error code ***/
echo $dbh->errorCode();
?>
The code above shows the error code relevant to the SQLSTATE. This is a five character string as defined by the ANSI SQL standard.
Connected to database
42S22
Further information about an error may be gained from the PDO::errorInfo() method. This returns an array containing the SQLSTATE, the error code, and the error message.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
/*** an invalid table name ***/
$sql = "SELECT animal_id FROM users";

/*** run the query ***/
$result = $dbh->query($sql);

/*** show the error info ***/
foreach($dbh->errorInfo() as $error)
    {
    echo $error.''<br />'';
    }
?>
With this code, the error information looks like this:
Connected to database
42S02
1146
Table ''animals.users'' doesn''t exist
If there is no error, the SQLSTATE will be the only value shown, with a value of 00000.
Prepared statements

What is a prepared statement? A prepared statement is a pre-compiled SQL statement that accepts zero or more named parameters. Ok, so thats my attempt at describing what it is, if you have a better description, let us know.
The SQL is prepared for execution. This is especially useful when using the same statement or query multiple times with different parameters, or field values. The boost in speed is hidden from userland code as the PDO driver allows client and server side caching of the query and meta data. It also helps prevent SQL injection by calling the PDO::quote() method internally.
PDO accepts two kinds of parameter markers.
named - :name
question mark - ?
You must choose one or the other, they cannot be mixed.
Lets dive in and have a look at how PDO::prepare and PDOStatement::execute work together.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** set the error reporting attribute ***/
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    /*** some variables ***/
    $animal_id = 6;

    $animal_name = ''bruce'';

    /*** prepare the SQL statement ***/
    $stmt = $dbh->prepare("SELECT * FROM animals WHERE animal_id = :animal_id AND animal_name = :animal_name");

    /*** bind the paramaters ***/
    $stmt->bindParam('':animal_id'', $animal_id, PDO::PARAM_INT);
    $stmt->bindParam('':animal_name'', $animal_name, PDO::PARAM_STR, 5);

    /*** execute the prepared statement ***/
    $stmt->execute();

    /*** fetch the results ***/
    $result = $stmt->fetchAll();

    /*** loop of the results ***/
    foreach($result as $row)
        {
        echo $row[''animal_id''].''<br />'';
        echo $row[''animal_type''].''<br />'';
        echo $row[''animal_name''];
        }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
The above code will produce the following:
Connected to database
6
wallaby
bruce
Errr, what was that?
What is this name = :variable business
What we have done is bind the variable named $animal_id and $animal_name to the statement. Remember this as many find it difficult to grasp. You are not binding the value of the variable, you are binding the variable itself. Lets change the value of the animal_id after the variable is bound and see what happens..
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** set the error reporting attribute ***/
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    /*** some variables ***/
    $animal_id = 6;

    $animal_name = ''bruce'';

    /*** prepare the SQL statement ***/
    $stmt = $dbh->prepare("SELECT * FROM animals WHERE animal_id = :animal_id AND animal_name = :animal_name");

    /*** bind the paramaters ***/
    $stmt->bindParam('':animal_id'', $animal_id, PDO::PARAM_INT);
    $stmt->bindParam('':animal_name'', $animal_name, PDO::PARAM_STR, 5);

    /*** reassign the animal_id ***/
    $animal_id = 3;

    /*** execute the prepared statement ***/
    $stmt->execute();

    /*** loop over the results ***/
    while($row = $stmt->fetch())
        {
        echo $row[''animal_id''].''<br />'';
        echo $row[''animal_type''].''<br />'';
        echo $row[''animal_name''];
        }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# Now see the results have changed
# Connected to database
# 3
# lizard
# bruce
# Because we have bound the variable $animal_id to the $stmt object any change to the value of that varible will be reflected in the statement. This format can be used for both SELECT and INSERT statements. But this is a bit cumbersome for a single query and the above PDO query could have done the job equally as well, so lets run the query multiple times. Ssimply by changing the animal_id and animal_name variables we can run the query over and over without re-writing as it is already ''prepared''.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** set the error reporting attribute ***/
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    /*** some variables ***/
    $animal_id = 6;
    $animal_name = ''bruce'';

    /*** prepare the SQL statement ***/
    $stmt = $dbh->prepare("SELECT * FROM animals WHERE animal_id = :animal_id AND animal_name = :animal_name");

    /*** bind the paramaters ***/
    $stmt->bindParam('':animal_id'', $animal_id, PDO::PARAM_INT);
    $stmt->bindParam('':animal_name'', $animal_name, PDO::PARAM_STR, 5);

    /*** reassign the animal_id ***/
    $animal_id = 3;
    $animal_name = ''kevin'';

    /*** execute the prepared statement ***/
    $stmt->execute();

    /*** loop over the results ***/
    while($row = $stmt->fetch())
        {
        echo $row[''animal_id''].''<br />'';
        echo $row[''animal_type''].''<br />'';
        echo $row[''animal_name''].''<br />'';
        }

    /*** reassign the animal_id ***/
    $animal_id = 7;
    $animal_name = ''bruce'';

    /*** execute the prepared statement ***/
    $stmt->execute();

    /*** loop over the results ***/
    while($row = $stmt->fetch())
        {
        echo $row[''animal_id''].''<br />'';
        echo $row[''animal_type''].''<br />'';
        echo $row[''animal_name''].''<br />'';
        }

    /*** reassign the animal_id ***/
    $animal_id = 4;
    /*** execute the prepared statement ***/
    $stmt->execute();

    /*** loop over the results ***/
    while($row = $stmt->fetch())
        {
        echo $row[''animal_id''].''<br />'';
        echo $row[''animal_type''].''<br />'';
        echo $row[''animal_name''];
        }

    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# Now we have run the query 3 times using the same prepared statement. The results look like this:
# Connected to database
# 7
# wombat
# bruce
# 4
# dingo
# bruce
# The second result set is missing as there is no animal named \''kevin\'', all Australians are named \''bruce\''. Note also in the above code we have changed the loop from foreach and PDOStatement::fetchAll() to a while loop using PDOStatement::fetch()As has been mentioned we can run this over and over, but while it is shorter than coding the query over and over, we can also use an array of values!
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** set the error reporting attribute ***/
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    /*** some variables ***/
    $data = array(''animal_id''=>6, ''animal_name''=>''bruce'');

    /*** prepare the SQL statement ***/
    $stmt = $dbh->prepare("SELECT * FROM animals WHERE animal_id = :animal_id AND animal_name = :animal_name");

    /*** bind the paramaters ***/
    $stmt->bindParam('':animal_id'', $animal_id, PDO::PARAM_INT);
    $stmt->bindParam('':animal_name'', $animal_name, PDO::PARAM_STR, 5);

    /*** reassign the variables ***/
    $data = array(''animal_id''=>3, ''animal_name'' => ''bruce'');

    /*** execute the prepared statement ***/
    $stmt->execute($data);

    /*** loop over the results ***/
    while($row = $stmt->fetch())
        {
        echo $row[''animal_id''].''<br />'';
        echo $row[''animal_type''].''<br />'';
        echo $row[''animal_name''].''<br />'';
        }

    /*** reassign the variables again ***/
    $data = array(''animal_id''=>4, ''animal_name'' => ''bruce'');

    /*** execute the prepared statement ***/
    $stmt->execute($data);

    /*** loop over the results ***/
    while($row = $stmt->fetch())
        {
        echo $row[''animal_id''].''<br />'';
        echo $row[''animal_type''].''<br />'';
        echo $row[''animal_name''].''<br />'';
        }

    /*** reassign the variables ***/
    $data = array(''animal_id''=>9, ''animal_name'' => ''bruce'');

    /*** execute the prepared statement ***/
    $stmt->execute($data);

    /*** loop over the results ***/
    while($row = $stmt->fetch())
        {
        echo $row[''animal_id''].''<br />'';
        echo $row[''animal_type''].''<br />'';
        echo $row[''animal_name''];
        }


    /*** close the database connection ***/
    $dbh = null;
}
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# Transactions

# At the beginning of this tutorial was saw multiple INSERT statements to set up the initial database. This works fine but is code intensive and with a database like SQLite a problem arises with file locking for each access. The process can be bundled into a single access by using a transaction. Transactions are quite simple and have the benifit of rolling back changes should an error occur, perhaps a system crash.
# A PDO transaction begins with the with PDO::beginTransaction() method. This method turns off auto-commit and any database statements or queries are not committed to the database until the transaction is committed with PDO::commit. When PDO::commit is called, all statements/queries are enacted and the database connection is returned to auto-commit mode.
# This example shows how we might set up the animals database used in this tutorial.
<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

/*** database name ***/
$dbname = ''animals'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=$dbname", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** set the PDO error mode to exception ***/
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    /*** begin the transaction ***/
    $dbh->beginTransaction();

    /*** CREATE table statements ***/
    $table = "CREATE TABLE animals ( animal_id MEDIUMINT(8) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    animal_type VARCHAR(25) NOT NULL,
    animal_name VARCHAR(25) NOT NULL 
    )";
    $dbh->exec($table);
    /***  INSERT statements ***/
    $dbh->exec("INSERT INTO animals (animal_type, animal_name) VALUES (''emu'', ''bruce'')");
    $dbh->exec("INSERT INTO animals (animal_type, animal_name) VALUES (''funnel web'', ''bruce'')");
    $dbh->exec("INSERT INTO animals (animal_type, animal_name) VALUES (''lizard'', ''bruce'')");
    $dbh->exec("INSERT INTO animals (animal_type, animal_name) VALUES (''dingo'', ''bruce'')");
    $dbh->exec("INSERT INTO animals (animal_type, animal_name) VALUES (''kangaroo'', ''bruce'')");
    $dbh->exec("INSERT INTO animals (animal_type, animal_name) VALUES (''wallaby'', ''bruce'')");
    $dbh->exec("INSERT INTO animals (animal_type, animal_name) VALUES (''wombat'', ''bruce'')");
    $dbh->exec("INSERT INTO animals (animal_type, animal_name) VALUES (''koala'', ''bruce'')");
    $dbh->exec("INSERT INTO animals (animal_type, animal_name) VALUES (''kiwi'', ''bruce'')");

    /*** commit the transaction ***/
    $dbh->commit();

    /*** echo a message to say the database was created ***/
    echo ''Data entered successfully<br />'';
}
catch(PDOException $e)
    {
    /*** roll back the transaction if we fail ***/
    $dbh->rollback();

    /*** echo the sql statement and error message ***/
    echo $sql . ''<br />'' . $e->getMessage();
    }
?>
# Get Last Insert Id

# This is a common task required when you need to get the id of the last INSERT. This is done with PDO::lastInserId() method as shown here.

<?php
/*** mysql hostname ***/
$hostname = ''localhost'';

/*** mysql username ***/
$username = ''username'';

/*** mysql password ***/
$password = ''password'';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=animals", $username, $password);
    /*** echo a message saying we have connected ***/
    echo ''Connected to database<br />'';

    /*** set the error reporting attribute ***/
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    /*** INSERT a new row ***/
    $dbh->exec("INSERT INTO animals(animal_type, animal_name) VALUES (''galah'', ''polly'')");

    /*** display the id of the last INSERT ***/
    echo $dbh->lastInsertId();

    /*** close the database connection ***/
    $dbh = null;
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# A Global Instance

# Ever need a global instance of your database connection? Here we achieve this with the use of the Singleton design patern. The goal of a singleton is to ensure the class has only a single instance and provide a global point of access to it. Here we use the getInstance() method to achieve this. A new instance is only created the first time it is accessed and all subsequent accesses are simply returned the existing instance.

<?php
class db{

/*** Declare instance ***/
private static $instance = NULL;

/**
*
* the constructor is set to private so
* so nobody can create a new instance using new
*
*/
private function __construct() {
  /*** maybe set the db name here later ***/
}

/**
*
* Return DB instance or create intitial connection
*
* @return object (PDO)
*
* @access public
*
*/
public static function getInstance() {

if (!self::$instance)
    {
    self::$instance = new PDO("mysql:host=''localhost'';dbname=''animals''", ''username'', ''password'');;
    self::$instance-> setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }
return self::$instance;
}

/**
*
* Like the constructor, we make __clone private
* so nobody can clone the instance
*
*/
private function __clone(){
}

} /*** end of class ***/

try    {
    /*** query the database ***/
    $result = DB::getInstance()->query("SELECT * FROM animals");

    /*** loop over the results ***/
    foreach($result as $row)
        {
        print $row[''animal_type''] .'' - ''. $row[''animal_name''] . ''<br />'';
        }
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
?>
# The above code will produce a result like this:
# emu - bruce
# funnel web - bruce
# lizard - bruce
# dingo - bruce
# kangaroo - bruce
# wallaby - bruce
# wombat - bruce
# koala - bruce
# This method of access saves the overhead created when a new instance of an object is called each time it is referenced, so you have have few references to it. Also, if you wish to pass the objects state from one reference to another there is no need to create from the initial state.
# Note that the constructor and clone methods have been made private to ensure that an instance of the class cannot be instantiated or cloned.
# Conclusions.
# 
# If you have got this far you will have seen how to create a connection, prepare a statement and exceute, and to bind Params using bindParam(). This is what most folks will be using to begin with and shows the effectiveness of using PDO to make code more portable. We highly recommend you visit http://www.php.net/manual/en/ref.pdo.php and read up on all that PDO has to offer.
',1337802990,1337802990,1,2,0,0,'FALSE',0);